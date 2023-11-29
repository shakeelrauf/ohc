# frozen_string_literal: true

class DeviceToken < ApplicationRecord
  include DeviceOperatingSystem

  has_many :users, dependent: :nullify

  validates :token, uniqueness: { scope: :device_operating_system, case_sensitive: false }, presence: true
  validates :device_operating_system, presence: true
end
