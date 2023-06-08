class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[registration register]
  before_action :require_registration, only: %i[registration register]
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
    if @user.save
      redirect_to users_path, notice: 'Пользователь создан.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def registration
    @user = User.new
  end

  def register
    @user = User.new(users_params)
    @user.is_admin = true
    if @user.save
      redirect_to root_path, notice: 'Регистрация выполнена.'
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
    if @user.destroyed?
      redirect_to users_path, notice: 'Пользователь удален.'
    else
      redirect_to users_path, notice: @user.errors.full_messages.to_sentence.capitalize
    end
  end

  private

  def users_params
    params.require(:user).permit(:name, :login, :email, :password, :password_confirmation, :is_admin)
  end

  def require_registration
    redirect_to root_path if User.first
  end

  def set_user
    @user = User.find(params[:id])
  end
end
