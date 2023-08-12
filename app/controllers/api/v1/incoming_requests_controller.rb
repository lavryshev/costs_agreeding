module Api
  module V1
    class IncomingRequestsController < Api::V1::AuthenticatedController
      def create_expense
        data = JSON.parse(request.body.read)
        @task = ServiceTask.create(external_app: current_external_app, action: 'create_expense', data:)

        ProcessIncomingRequestJob.perform_later

        render json: { command_id: @task.id, result: 'success' }, status: :ok
      end
    end
  end
end
