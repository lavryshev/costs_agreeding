module Api
  module V1
    class ExpensesController < Api::V1::AuthenticatedController
      def create
        task = ServiceTask.create(external_app: current_external_app, action: 'create_expense', data: expense_params)
        render json: { command_id: task.id }, status: :ok
      end

      def update
        task = ServiceTask.create(external_app: current_external_app, action: 'update_expense', data: expense_params)
        render json: { command_id: task.id }, status: :ok
      end

      def destroy
        task = ServiceTask.create(external_app: current_external_app, action: 'destroy_expense', data: expense_params)
        render json: { command_id: task.id }, status: :ok
      end

      private

      def expense_params
        params.permit(:id, :source_id, :sum, :payment_date, :description)
      end
    end
  end
end
