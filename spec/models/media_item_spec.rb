# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaItem, type: :model do
  it { is_expected.to belong_to(:camp).optional }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_attached_of(:attachment) }
  it { is_expected.to validate_content_type_of(:attachment).allowing(['image/png', 'image/jpg', 'image/jpeg', 'video/mp4']) }
  it { is_expected.to validate_size_of(:attachment).less_than(300.megabytes) }
end
