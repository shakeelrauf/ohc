# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Theme, type: :model do
  it { is_expected.to belong_to(:camp_location).optional }
  it { is_expected.to have_many(:quiz_questions).dependent(:destroy) }
  it { is_expected.to have_many(:scores).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name) }
end
