module Api
  module V1
    class AuthenticatedController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      attr_reader :current_external_app

      def authenticate
        authenticate_app_with_token || handle_bad_authentication
      end

      private

      def authenticate_app_with_token
        authenticate_with_http_token do |token, _options|
          @current_external_app = ExternalApp.find_by(token:)
          if @current_external_app
            @current_external_app = @current_external_app.active ? @current_external_app : nil
          end
        end
      end

      def handle_bad_authentication
        render json: { message: 'Bad credentials' }, status: :unauthorized
      end
    end
  end
end
