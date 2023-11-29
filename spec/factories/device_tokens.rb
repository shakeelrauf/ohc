# frozen_string_literal: true

FactoryBot.define do
  factory :device_token do
    token { generate(:string) }
    device_operating_system { DeviceToken.device_operating_systems[:ios] }
  end
end
