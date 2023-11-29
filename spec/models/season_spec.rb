# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Season, type: :model do
  it { is_expected.to belong_to(:camp_location) }

  it { is_expected.to have_many(:camps).dependent(:destroy) }
  it { is_expected.to have_many(:children).through(:camps) }
  it { is_expected.to have_many(:users).through(:camps).dependent(:restrict_with_error) }

  it { is_expected.to validate_presence_of(:name) }
end
