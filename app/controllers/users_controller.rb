class UsersController < ApplicationController
  skip_before_action :require_login, only: [:registration, :register]
  before_action :require_registration, only: [:registration, :register]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      redirect_to users_path, notice: "Пользователь создан."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def registration
    @user = User.new
  end

  def register
    @user = User.new(users_params)
    if @user.save
      redirect_to root_path, notice: "Регистрация выполнена."
    else
      render :registration, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(users_params)
      redirect_to users_path, notice: 'Пользователь изменен успешно.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Пользователь удален.'
  end

  private

  def users_params
    params.require(:user).permit(:name, :login, :email, :password, :password_confirmation)
  end

  def require_registration
    redirect_to root_path if User.first
  end

  def set_user
    @user = User.find(params[:id])
  end
end
