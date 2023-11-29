# frozen_string_literal: true

class API::V2::DeviceTokenSerializer < API::V2::ApplicationSerializer
  set_type :device_token

  attributes :token, :device_operating_system
end
