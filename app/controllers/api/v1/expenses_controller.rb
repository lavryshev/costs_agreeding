module Api
  module V1
    class ExpensesController < Api::V1::AuthenticatedController

      def create
        task = ServiceTask.create(external_app: current_external_app, action: 'create_expense', data: expense_params)
        render json: { command_id: task.id }, status: :ok
      end

      def update

      end

      def destroy

      end

      private

      def expense_params
        params.permit(:source_id, :sum, :payment_date, :description)
      end

    end
  end
end
