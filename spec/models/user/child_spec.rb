# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Child, type: :model do
  it { is_expected.to have_many(:camp_locations).through(:camps) }

  it { is_expected.to validate_presence_of(:date_of_birth) }
end
