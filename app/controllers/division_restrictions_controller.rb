class DivisionRestrictionsController < ApplicationController
  before_action :set_users_group

  def create
    @division_restriction = @users_group.division_restrictions.create(division_restriction_params)

    redirect_to users_group_path(@users_group)
  end

  def destroy
    @division_restriction = @users_group.division_restrictions.find(params[:id])
    @division_restriction.destroy

    redirect_to users_group_path(@users_group)
  end

  private

  def division_restriction_params
    params.require(:division_restriction).permit(:division_id)
  end

  def set_users_group
    @users_group = UsersGroup.find(params[:users_group_id])
  end
end
