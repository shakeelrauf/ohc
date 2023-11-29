# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeviceToken, type: :model do
  it { is_expected.to have_many(:users) }

  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_presence_of(:device_operating_system) }
end
