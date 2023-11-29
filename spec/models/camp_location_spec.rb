# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampLocation, type: :model do
  it { is_expected.to have_many(:admins).dependent(:restrict_with_error).class_name('User::Admin') }
  it { is_expected.to have_many(:camps).through(:seasons) }
  it { is_expected.to have_many(:children).through(:seasons) }
  it { is_expected.to have_many(:seasons).dependent(:destroy) }
  it { is_expected.to have_many(:themes).dependent(:destroy) }
  it { is_expected.to have_many(:users).through(:seasons).dependent(:restrict_with_error) }

  it { is_expected.to validate_presence_of(:name) }
end
