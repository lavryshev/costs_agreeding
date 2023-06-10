class ExpensesController < ApplicationController
  before_action :require_login, only: %i[new create edit update destroy]
  before_action :require_agree_permission, only: %i[agree disagree]
  before_action :set_expense, only: %i[edit update destroy agree disagree]

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expense_params)
    @expense.status = ExpenseStatus.not_agreed
    @expense.author = current_user

    if @expense.save
      redirect_to root_path, notice: 'Заявка создана успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @expense.update(expense_params)
      redirect_to root_path, notice: 'Заявка изменена успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to root_path, notice: 'Заявка удалена.'
  end

  def agree
    @expense.status = ExpenseStatus.agreed
    @expense.responsible = current_user
    @expense.save
    render :edit, status: :unprocessable_entity
  end

  def disagree
    @expense.status = ExpenseStatus.rejected
    @expense.responsible = current_user
    @expense.save
    render :edit, status: :unprocessable_entity
  end

  private

  def expense_params
    params.require(:expense).permit(:sum, :payment_date, :description, :notes, :source_sgid)
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end
end
