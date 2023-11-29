# frozen_string_literal: true

module API
  module V2
    class UsersController < BaseController
      # == [GET] /api/v2/user.json
      # Fetch the current user
      # ==== Returns
      # * 200 - success - returns the user
      def show
        user = current_user

        render json: API::V2::UserSessionSerializer.new(user, serializer_params)
      end

      # == [PUT] /api/v2/user.json
      # Update the current user
      # ==== Optional
      # * avatar - a string representing the user's avatar choice ('duck', 'bear')
      # * live_event_notification - the users new notification preference
      # ==== Returns
      # * 200 - success - returns the user
      # * 422 - failure - user could not be updated
      def update
        user = current_user

        if user.update(allowed_params)
          render json: API::V2::UserSessionSerializer.new(user, serializer_params)
        else
          render_object_error object: user, serializer: API::V2::UserSessionSerializer, status: :unprocessable_entity
        end
      end

      private

      def allowed_params
        params.from_jsonapi.require(:user).permit(:avatar, :live_event_notification)
      end
    end
  end
end
