# frozen_string_literal: true

FactoryBot.define do
  factory :theme do
    name { generate(:string) }
    active { true }

    association :tenant
  end
end
