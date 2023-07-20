class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_agree_permission, only: %i[agree disagree]
  before_action :set_expense, only: %i[edit update destroy agree disagree]

  def index
    @sort = sort_params

    @filter_params = filter_by_status_params
    @filtered_statuses_id = @filter_params.select { |_name, id| id.to_i.positive? }.values

    @expenses = @filtered_statuses_id.empty? ? Expense : Expense.by_status(@filtered_statuses_id)
    @expenses = @expenses.merge(Expense.order_by(@sort[:field], @sort[:direction]))
    @expenses = @expenses.page params[:page]
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expense_params)
    @expense.status = ExpenseStatus.not_agreed
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
    @expense.status = ExpenseStatus.agreed
    @expense.responsible = current_user
    @expense.save

    add_status_change_report

    render :edit, status: :unprocessable_entity
  end

  def disagree
    @expense.status = ExpenseStatus.rejected
    @expense.responsible = current_user
    @expense.save

    add_status_change_report

    render :edit, status: :unprocessable_entity
  end

  private

  def expense_params
    params.require(:expense).permit(:sum, :payment_date, :description, :notes, :source_sgid)
  end

  def filter_by_status_params
    params.permit(:f_not_agreed, :f_agreed, :f_rejected)
  end

  def sort_params
    params.permit(:field, :direction)
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def add_status_change_report
    StatusChangedReport.create(expense: @expense, responsible: @expense.responsible, status: @expense.status)
    ProcessStatusChangedReportsJob.perform_later
  end
end
