module Api
  module V1
    class AuthenticatedController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      attr_reader :current_api_user

      def authenticate
        authenticate_user_with_token || handle_bad_authentication
      end

      private

      def authenticate_user_with_token
        authenticate_with_http_token do |token, _options|
          @current_api_user = ApiUser.find_by(token:)
          if @current_api_user
            @current_api_user = @current_api_user.active ? @current_api_user : nil
          end
        end
      end

      def handle_bad_authentication
        render json: { message: 'Bad credentials' }, status: :unauthorized
      end
    end
  end
end
