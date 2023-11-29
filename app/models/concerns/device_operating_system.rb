# frozen_string_literal: true

module DeviceOperatingSystem
  extend ActiveSupport::Concern

  included do
    enum device_operating_system: { android: 'android', ios: 'ios' }
  end
end
