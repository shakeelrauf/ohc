# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CamperQuestion, type: :model do
  it { is_expected.to belong_to(:admin).class_name('User::Admin').optional }
  it { is_expected.to belong_to(:child).class_name('User::Child') }
  it { is_expected.to belong_to(:attendance) }

  it { is_expected.to validate_presence_of(:text) }
end
