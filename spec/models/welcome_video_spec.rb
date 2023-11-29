# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeVideo, type: :model do
  it { is_expected.to have_many(:cabins).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:camps).dependent(:restrict_with_error) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_attached_of(:video) }
  it { is_expected.to validate_content_type_of(:video).allowing('video/mp4') }
  it { is_expected.to validate_size_of(:video).less_than(20.megabytes) }
end
