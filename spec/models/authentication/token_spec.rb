# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication::Token, type: :model do
  it { is_expected.to belong_to(:authentication) }
end
