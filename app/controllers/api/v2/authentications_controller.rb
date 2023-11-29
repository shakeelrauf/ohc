# frozen_string_literal: true

module API
  module V2
    class AuthenticationsController < BaseController
      skip_before_action :authenticate_user

      # == [POST] /api/v2/authentications.json
      # Create a new authentication
      # ==== Required
      # * code - the registering attendance's code
      # * dob - the registering attendance's Date of Birth
      # * username - the authentications username
      # * password - the authentications passsword
      # ==== Returns
      # * 200 - success - returns the authentication with a token
      # * 403 - failure - user is already registered
      # * 422 - failure - username is taken
      def create
        attendance = fetch_attendance(attendance_params[:code], attendance_params[:dob])

        if attendance.user.registered?
          head :forbidden
          return
        end

        authentication = Authentication.new(allowed_params.merge(users: [attendance.user]))

        if authentication.save
          authentication.ensure_api_token!(request.remote_ip, request.user_agent)

          render json: API::V2::AuthenticationSerializer.new(authentication), status: :created
        else
          render_object_error(object: authentication, serializer: API::V2::AuthenticationSerializer)
        end
      end

      # == [GET] /api/v2/authentications/check_username.json
      # Check if a username has been taken
      # ==== Required
      # * username - the username to check
      # ==== Returns
      # * 200 - success - username is not taken
      # * 422 - failure - username is taken
      def check_username
        if Authentication.exists?(username: params[:username])
          head :unprocessable_entity
        else
          head :ok
        end
      end

      private

      def allowed_params
        params.from_jsonapi.require(:authentication).permit(:password, :username)
      end

      def attendance_params
        params.from_jsonapi.require(:authentication).permit(:code, :dob)
      end

      def fetch_attendance(code, date_of_birth)
        Attendance.joins(:user)
                  .find_by!(code: code, users: { date_of_birth: date_of_birth })
      end
    end
  end
end
