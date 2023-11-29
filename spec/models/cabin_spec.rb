# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cabin, type: :model do
  it { is_expected.to belong_to(:welcome_video).optional }
  it { is_expected.to belong_to(:camp) }

  it { is_expected.to have_one(:camp_location).through(:camp) }

  it { is_expected.to have_many(:admins).through(:attendances) }
  it { is_expected.to have_many(:attendances).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:children).through(:attendances) }
  it { is_expected.to have_many(:targets).dependent(:destroy) }
  it { is_expected.to have_many(:events).through(:targets) }
  it { is_expected.to have_many(:users).through(:attendances) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_attached_of(:video) }
  it { is_expected.to validate_content_type_of(:video).allowing('video/mp4') }
  it { is_expected.to validate_size_of(:video).less_than(20.megabytes) }

  describe 'when using a welcome video' do
    it 'does not require an attached video' do
      cabin = build(:cabin, video: nil, welcome_video: create(:welcome_video))

      expect(cabin.valid?).to eq(true)
    end
  end
end
