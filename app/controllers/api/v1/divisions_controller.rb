module Api
  module V1
    class DivisionsController < Api::V1::AuthenticatedController
      before_action :set_division, only: %i[update destroy]

      def create
        @division = Division.new(division_params)
        @division.organization = Organization.find_by(externalid: params['organization_externalid'])

        if @division.save
          render json: { 'message' => 'Division created.' }, status: :created
        else
          render json: { 'errors' => @division.errors.full_messages.to_sentence.capitalize },
                 status: :unprocessable_entity
        end
      end

      def update
        @division.organization = Organization.find_by(externalid: params['organization_externalid'])

        if @division.update(division_params)
          render json: { 'message' => 'Expense updated.' }, status: :ok
        else
          render json: { 'errors' => @division.errors.full_messages.to_sentence.capitalize },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @division.destroy
        render json: { 'message' => 'Expense deleted.' }, status: :ok
      end

      private

      def division_params
        params.permit(:externalid, :name)
      end

      def set_division
        @division = Division.find_by(externalid: params[:externalid])
      end
    end
  end
end
