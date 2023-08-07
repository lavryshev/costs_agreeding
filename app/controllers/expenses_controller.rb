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
    @expense.update(status: 'agreed', responsible: current_user)
    flash[:alert] = 'Заявка согласована'
    render :edit, status: :unprocessable_entity
  end

  def disagree
    @expense.update(status: 'rejected', responsible: current_user)
    flash[:alert] = 'Заявка отклонена'
    render :edit, status: :unprocessable_entity
  end

  private

  def expense_params
    params.require(:expense).permit(:sum, :payment_date, :description, :notes, :source_sgid)
  end

  def apply_filter_and_sort
    @sorting = params.permit(:field, :direction)
    @selected_filters = params.permit(:statuses => [])

    @expenses = Expense.where(nil)
    @expenses = @expenses.filter_by_status(@selected_filters[:statuses]) if @selected_filters[:statuses].present?
    @expenses = @expenses.merge(Expense.order_by(@sorting[:field], @sorting[:direction]))
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end
end
