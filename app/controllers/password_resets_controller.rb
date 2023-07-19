class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      redirect_to root_path, notice: 'Инструкция по восстановлению пароля отправлена по электронной почте.'
    else
      flash[:alert] = 'Пользователь с таким адресом электронной почты не найден!'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(perishable_token: params[:id])
  end

  def update
    @user = User.find_by(perishable_token: params[:id])
    if @user.update(password_reset_params)
      redirect_to root_path, notice: 'Пароль успешно обновлен.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
