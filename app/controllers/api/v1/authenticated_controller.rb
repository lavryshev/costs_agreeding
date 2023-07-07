class Api::V1::AuthenticatedController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  attr_reader :current_api_user

  def authenticate
    authenticate_user_with_token || handle_bad_authentication
  end

  private

  def authenticate_user_with_token
    authenticate_with_http_token do |token, options|
      @current_api_user = ApiUser.where(active: true).find_by(token: token)
    end
  end

  def handle_bad_authentication
    render json: { message: 'Bad credentials' }, status: :unauthorized
  end

end