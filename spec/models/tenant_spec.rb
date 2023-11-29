# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenant, type: :model do
  it { is_expected.to belong_to(:color_theme) }

  it { is_expected.to have_many(:camp_locations).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:camper_questions).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:contact_email_messages).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:custom_labels).dependent(:destroy) }
  it { is_expected.to have_many(:events).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:imports).dependent(:destroy) }
  it { is_expected.to have_many(:media_items).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:themes).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:users).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:welcome_videos).dependent(:restrict_with_error) }

  # STI User Classes
  it { is_expected.to have_many(:admins) }
  it { is_expected.to have_many(:children) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:max_users) }
  it { is_expected.to validate_presence_of(:max_stream_hours) }
  it { is_expected.to validate_numericality_of(:max_users).only_integer.is_greater_than(0).is_less_than(1_000_000) }
  it { is_expected.to validate_numericality_of(:max_stream_hours).only_integer.is_greater_than(0).is_less_than(1_000_000) }

  it { is_expected.to validate_content_type_of(:logo).allowing(['image/png', 'image/jpg', 'image/jpeg']) }
  it { is_expected.to validate_size_of(:logo).less_than(20.megabytes) }
end
