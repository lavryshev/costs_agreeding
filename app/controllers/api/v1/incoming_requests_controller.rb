class Api::V1::IncomingRequestsController < Api::V1::AuthenticatedController

  def create_expense
    render json: { message: 'Create expense' }
  end

end