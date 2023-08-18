module Api
  module V1
    class OrganizationsController < Api::V1::AuthenticatedController
      before_action :set_organization, only: %i[update destroy]

      def create
        @organization = Organization.new(organization_params)

        if @organization.save
          render json: { 'message' => 'Organization created.' }, status: :created
        else
          render json: { 'errors' => @organization.errors.full_messages.to_sentence.capitalize },
                 status: :unprocessable_entity
        end
      end

      def update
        if @organization.update(organization_params)
          render json: { 'message' => 'Expense updated.' }, status: :ok
        else
          render json: { 'errors' => @organization.errors.full_messages.to_sentence.capitalize },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @organization.destroy
        render json: { 'message' => 'Expense deleted.' }, status: :ok
      end

      private

      def organization_params
        params.permit(:externalid, :name)
      end

      def set_organization
        @organization = Organization.find_by(externalid: params[:externalid])
      end
    end
  end
end
