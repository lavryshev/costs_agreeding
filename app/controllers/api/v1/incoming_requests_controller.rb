module Api
  module V1
    class IncomingRequestsController < Api::V1::AuthenticatedController
      def create_expense
        data = JSON.parse(request.body.read)
        @incoming_request = IncomingRequest.create(api_user: current_api_user, action: 'create_expense', data:)

        ProcessIncomingRequestJob.perform_later

        render json: { command_id: @incoming_request.id, result: 'success' }, status: :ok
      end
    end
  end
end
