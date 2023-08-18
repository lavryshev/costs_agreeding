class UsersGroupsController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_users_group, only: %i[show edit update destroy]

  def index
    @users_groups = UsersGroup.all
  end

  def new
    @users_group = UsersGroup.new
  end

  def create
    @users_group = UsersGroup.create(users_group_params)

    if @users_group.save
      redirect_to users_group_path(@users_group), notice: 'Группа пользователей создана успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @users_group.update(users_group_params)
      redirect_to users_group_path(@users_group), notice: 'Группа пользователей изменена успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @users_group.destroy
    if @users_group.destroyed?
      redirect_to users_groups_path, notice: 'Группа пользователей удалена.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_users_group
    @users_group = UsersGroup.find(params[:id])
  end

  def users_group_params
    params.require(:users_group).permit(:name)
  end
end
