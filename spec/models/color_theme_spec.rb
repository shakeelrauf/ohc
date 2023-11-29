# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ColorTheme, type: :model do
  it { is_expected.to have_many(:tenants) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:primary_color) }
  it { is_expected.to validate_presence_of(:secondary_color) }
  it { is_expected.to validate_presence_of(:app_layout) }
  it { is_expected.to validate_inclusion_of(:app_layout).in_array(described_class::APP_LAYOUTS) }
end
