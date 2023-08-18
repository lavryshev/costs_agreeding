class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user, :require_login, :require_admin

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)

    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = current_user_session&.user
  end

  def require_login
    if !User.first
      redirect_to registration_path
    elsif !current_user
      redirect_to new_user_session_path
    end
  end

  def require_admin
    redirect_to permission_error_path unless current_user&.is_admin
  end

  def require_expense_permitted
    expense = Expense.find(params[:id])
    redirect_to permission_error_path unless expense.permitted?(current_user)
  end
end
