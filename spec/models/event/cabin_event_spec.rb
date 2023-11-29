# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::CabinEvent, type: :model do
  it { is_expected.to have_many(:targets) }
  it { is_expected.to have_many(:cabins).through(:targets) }
end
