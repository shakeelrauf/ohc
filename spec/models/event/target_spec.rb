# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::Target, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:target) }
end
