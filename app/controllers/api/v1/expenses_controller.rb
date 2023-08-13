module Api
  module V1
    class ExpensesController < Api::V1::AuthenticatedController
      before_action :set_expense, only: %i[update destroy]

      def create
        @expense = Expense.new(expense_params)
        @expense.source = Source.find_by(externalid: params['source_externalid'])
        @expense.organization = Organization.find_by(externalid: params['organization_externalid'])
        @expense.external_app = current_external_app

        if @expense.save
          render json: { 'message' => 'Expense created.' }, status: :created
        else
          render json: { 'errors' => @expense.errors.full_messages.to_sentence.capitalize },
                 status: :unprocessable_entity
        end
      end

      def update
        if @expense.update(expense_params)
          render json: { 'message' => 'Expense updated.' }, status: :ok
        else
          render json: { 'errors' => @expense.errors.full_messages.to_sentence.capitalize },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @expense.destroy
        render json: { 'message' => 'Expense deleted.' }, status: :ok
      end

      private

      def expense_params
        params.permit(:externalid, :sum, :payment_date, :description)
      end

      def set_expense
        @expense = Expense.find_by(externalid: params[:externalid])
      end
    end
  end
end
