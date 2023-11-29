# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Camp, type: :model do
  let(:camp) { described_class.new }

  it { is_expected.to belong_to(:welcome_video).optional }
  it { is_expected.to belong_to(:season) }

  it { is_expected.to have_one(:camp_location).through(:season) }

  it { is_expected.to have_many(:admins).through(:attendances).source(:user) }
  it { is_expected.to have_many(:attendances).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:children).through(:attendances).source(:user) }
  it { is_expected.to have_many(:cabins).dependent(:destroy) }
  it { is_expected.to have_many(:media_items).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:targets).dependent(:destroy) }
  it { is_expected.to have_many(:events).through(:targets) }
  it { is_expected.to have_many(:imports) }
  it { is_expected.to have_many(:users).through(:attendances).dependent(:restrict_with_error) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_attached_of(:video) }
  it { is_expected.to validate_content_type_of(:video).allowing('video/mp4') }
  it { is_expected.to validate_size_of(:video).less_than(20.megabytes) }

  it 'has many admins' do
    expect(camp).to(have_many(:admins).class_name('User::Admin')
                                      .through(:attendances)
                                      .source(:user))
  end

  it 'has many children' do
    expect(camp).to(have_many(:children).class_name('User::Child')
                                      .through(:attendances)
                                      .source(:user))
  end

  describe 'when using a welcome video' do
    it 'does not require an attached video' do
      camp = build(:camp, video: nil, welcome_video: create(:welcome_video))

      expect(camp.valid?).to eq(true)
    end
  end
end
