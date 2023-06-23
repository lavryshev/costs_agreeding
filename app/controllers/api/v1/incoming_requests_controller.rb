class Api::V1::IncomingRequestsController < Api::V1::AuthenticatedController

  def create_expense
    @incoming_request = IncomingRequest.create(api_user: current_api_user, action: 'create_expense', data: request.body.read)
    if @incoming_request.save
      render json: {message: 'Success'}, status: :ok
    else
      render json: {message: 'Error'}, status: :internal_server_error
    end
  end

end