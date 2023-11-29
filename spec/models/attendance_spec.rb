# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attendance, type: :model do
  it { is_expected.to belong_to(:cabin) }
  it { is_expected.to belong_to(:camp) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:camp_location).through(:camp) }
  it { is_expected.to have_many(:camper_questions).dependent(:nullify) }

  it { is_expected.to validate_length_of(:code).is_equal_to(16) }
  it { is_expected.to validate_presence_of(:cabin_id) }
end
