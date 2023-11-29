# frozen_string_literal: true

FactoryBot.define do
  factory :authentication do
    username { generate(:string) }
    password { 'myPass145' }
  end
end
