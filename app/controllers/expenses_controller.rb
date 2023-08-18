class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_expense_permitted, only: %i[agree disagree]
  before_action :set_expense, only: %i[show agree disagree]

  def index
    apply_filter_and_sort
    @expenses = @expenses.page params[:page]
  end

  def show

  end

  def agree
    @expense.update(status: 'agreed', responsible: current_user)
    redirect_to expense_path(@expense), notice: 'Заявка утверджена.'
  end

  def disagree
    @expense.update(status: 'rejected', responsible: current_user)
    redirect_to expense_path(@expense), notice: 'Заявка отклонена.'
  end

  private

  def apply_filter_and_sort
    @sorting = params.permit(:field, :direction)
    @selected_filters = params.permit(statuses: [])

    @expenses = Expense.all_permitted(current_user).merge(Expense.filter(@selected_filters))
    @expenses = @expenses.merge(Expense.order_by(@sorting[:field], @sorting[:direction]))
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end
end
