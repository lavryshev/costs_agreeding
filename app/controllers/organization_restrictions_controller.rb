class OrganizationRestrictionsController < ApplicationController
  before_action :set_users_group

  def create
    @organization_restriction = @users_group.organization_restrictions.create(organization_restriction_params)

    redirect_to users_group_path(@users_group)
  end

  def destroy
    @organization_restriction = @users_group.organization_restrictions.find(params[:id])
    @organization_restriction.destroy

    redirect_to users_group_path(@users_group)
  end

  private

  def organization_restriction_params
    params.require(:organization_restriction).permit(:organization_id)
  end

  def set_users_group
    @users_group = UsersGroup.find(params[:users_group_id])
  end
end
