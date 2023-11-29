# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    name { 'Contact Email' }
    value { 'test@test.com' }
  end
end
