class UsersGroupMembersController < ApplicationController
  before_action :set_users_group

  def create
    @users_group_member = @users_group.users_group_members.create(users_group_member_params)

    redirect_to users_group_path(@users_group)
  end

  def destroy
    @users_group_member = @users_group.users_group_members.find(params[:id])
    @users_group_member.destroy

    redirect_to users_group_path(@users_group)
  end

  private

  def users_group_member_params
    params.require(:users_group_member).permit(:user_id)
  end

  def set_users_group
    @users_group = UsersGroup.find(params[:users_group_id])
  end
end
