class PasswordResetMailer < ApplicationMailer
  def reset_email(user)
    @user = user
    mail(to: @user.email, subject: 'Инструкция по сбросу пароля')
  end
end
