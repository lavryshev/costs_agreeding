class Api::V1::ExpensesController < Api::V1::AuthenticatedController

  def create
    render json: { message: 'Create expense' }
  end

end