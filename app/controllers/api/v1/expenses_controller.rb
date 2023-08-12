module Api
  module V1
    class ExpensesController < Api::V1::AuthenticatedController

      before_action :parse_data

      def create
        task = ServiceTask.create(external_app: current_external_app, action: 'create_expense', data: @data)
        render json: { command_id: task.id }, status: :ok
      end

      def update

      end

      def destroy

      end

      private

      def parse_data
        @data = JSON.parse(request.body.read)
      end

    end
  end
end
