class ExpensesController < ApplicationController
  before_action :require_login
  before_action :require_agree_permission, only: %i[agree disagree]
  before_action :set_expense, only: %i[agree disagree]

  def index
    apply_filter_and_sort
    @expenses = @expenses.page params[:page]
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
    params.require(:expense).permit(:sum, :payment_date, :description, :notes, :source)
  end

  def apply_filter_and_sort
    @sorting = params.permit(:field, :direction)
    @selected_filters = params.permit(statuses: [])

    @expenses = Expense.filter(@selected_filters)
    @expenses = @expenses.merge(Expense.order_by(@sorting[:field], @sorting[:direction]))
  end

  def set_expense
    @expense = Expense.find(params[:id])
  end
end
