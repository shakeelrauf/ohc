# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomLabel, type: :model do
  it { is_expected.to belong_to(:tenant) }

  it { is_expected.to validate_presence_of(:class_name) }
  it { is_expected.to validate_inclusion_of(:class_name).in_array(described_class::CLASSES) }
end
