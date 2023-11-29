# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::CampEvent, type: :model do
  it { is_expected.to have_many(:targets) }
  it { is_expected.to have_many(:camps).through(:targets) }
end
