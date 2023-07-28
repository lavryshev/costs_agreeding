class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_agree_permission, only: %i[agree disagree]
  before_action :set_expense, only: %i[edit update destroy agree disagree]

  def index
    apply_filter_and_sort
    @expenses = @expenses.page params[:page]
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expense_params)
    @expense.author = current_user

    if @expense.save
      redirect_to expenses_path, notice: 'Заявка создана успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: 'Заявка изменена успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: 'Заявка удалена.'
  end

  def agree
    @expense.status = 'agreed'
    @expense.responsible = current_user
    @expense.save

    add_status_change_report if @expense.api_user

    render :edit, status: :unprocessable_entity
  end

  def disagree
    @expense.status = 'rejected'
    @expense.responsible = current_user
    @expense.save

    add_status_change_report if @expense.api_user

    render :edit, status: :unprocessable_entity
  end

  private

  def expense_params
    params.require(:expense).permit(:sum, :payment_date, :description, :notes, :source_sgid)
  end

  def sorrting_params
    sorting = params.permit(:field, :direction)
    if sorting.empty?
      sorting = session['expense_sorting'] if session['expense_sorting']
    else
      session['expense_sorting'] = sorting
    end
  end

  def filter_by_status_params
    filter_by_status = params.permit(:f_not_agreed, :f_agreed, :f_rejected)
    if filter_by_status.empty?
      filter_by_status = session['expense_filter_by_status'] if session['expense_filter_by_status']
    else
      session['expense_filter_by_status'] = filter_by_status
    end
  end

  def apply_filter_and_sort
    @sorting = sorrting_params
    
    filter_by_status = filter_by_status_params
    @filter = filter_by_status
    @filtered_status_values = filter_by_status.select { |_name, value| value.to_i >= 0 }.values

    @expenses = Expense.where(nil)
    @expenses = Expense.by_status(@filtered_status_values) unless @filtered_status_values.empty?
    @expenses = @expenses.merge(Expense.order_by(@sorting[:field], @sorting[:direction]))
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def add_status_change_report
    StatusChangedReport.create(expense: @expense, responsible: @expense.responsible,
                               status: @expense.status_before_type_cast)
    ProcessStatusChangedReportsJob.perform_later
  end
end
