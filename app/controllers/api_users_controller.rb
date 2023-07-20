class ApiUsersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_api_user, only: %i[edit update destroy]

  def index
    @api_users = ApiUser.all
  end

  def new
    @api_user = ApiUser.new
  end

  def create
    @api_user = ApiUser.create(api_user_params)

    if @api_user.save
      redirect_to api_users_path, notice: 'Пользователь API создан успешно.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @api_user.update(api_user_params)
      redirect_to api_users_path, notice: 'Пользователь API изменен успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @api_user.destroy
    redirect_to api_users_path, notice: 'Пользователь API удален.'
  end

  private

  def api_user_params
    params.require(:api_user).permit(:name, :active, :webhook_url)
  end

  def set_api_user
    @api_user = ApiUser.find(params[:id])
  end
end
