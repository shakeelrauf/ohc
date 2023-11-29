# frozen_string_literal: true

module API
  module V2
    class AttendancesController < BaseController
      skip_before_action :authenticate_user

      # == [GET] /api/v2/attendances/:code.json
      # Fetch an attendance for an unregistered user via Code and Date of Birth
      # ==== Required
      # * code (in URL) - code for this attendance
      # * dateOfBirth - necessary to verify child authentication
      # ==== Returns
      # * 200 - success - returns the attendance
      # * 403 - failure - attendance user is already registered
      # * 404 - failure - attendance or child not found, or date of birth did not match
      def show
        attendance = fetch_attendance(params[:code], params[:dateOfBirth])

        if attendance.user.registered?
          head :forbidden
          return
        end

        render json: API::V2::AttendanceSerializer.new(attendance)
      end

      # == [POST] /api/v2/attendances/:code.json
      # Attach a user to the current authentication via an attendance
      # ==== Required
      # * code - code for this attendance
      # * date_of_birth - the date of birth of the attendance user
      # ==== Returns
      # * 200 - success - returns the attendance
      # * 403 - failure - attendance user is already registered
      # * 404 - failure - attendance or child not found, or date of birth did not match
      def create
        attendance = fetch_attendance(allowed_params[:code], allowed_params[:date_of_birth])

        if !current_authentication || attendance.user.registered?
          head :forbidden
          return
        end

        # Attach the attendance user to the current authentication
        attendance.user.update(authentication_id: current_authentication.id)

        render json: API::V2::AttendanceSerializer.new(attendance, serializer_params)
      end

      private

      def allowed_params
        params.from_jsonapi.require(:attendance).permit(:code, :date_of_birth)
      end

      def fetch_attendance(code, date_of_birth)
        Attendance.joins(:user)
                  .find_by!(code: code, users: { date_of_birth: date_of_birth })
      end
    end
  end
end
