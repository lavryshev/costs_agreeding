class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_agree_permission, only: %i[agree disagree]
  before_action :set_expense, only: %i[edit update destroy agree disagree]

  def index
    if params[:field]
      sort_by = params[:field]
    else
      sort_by = 'created_at'
    end
    @expenses = Expense.order("#{sort_by} #{params[:direction]}").page params[:page]
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

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def add_status_change_report
    StatusChangedReport.create(expense: @expense, responsible: @expense.responsible, status: @expense.status)
    ProcessStatusChangedReportsJob.perform_later
  end
end
