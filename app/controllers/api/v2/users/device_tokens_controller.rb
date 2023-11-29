# frozen_string_literal: true

module API
  module V2
    module Users
      class DeviceTokensController < BaseController
        # == [POST] /api/v2/users/device_token.json
        # Create or update a device token for a user
        # ==== Required
        # * token - the push notification token for device
        # * device_operating_system - the device operating system
        def create
          token = DeviceToken.find_or_create_by(allowed_params)

          if token.persisted? && current_user.update(device_token: token)
            render json: API::V2::DeviceTokenSerializer.new(token, serializer_params), status: :created
          else
            render_object_error object: token, serializer: API::V2::DeviceTokenSerializer, status: :unprocessable_entity
          end
        end

        private

        def allowed_params
          params.from_jsonapi.require(:device_token).permit(:token, :device_operating_system)
        end
      end
    end
  end
end
