# frozen_string_literal: true

FactoryBot.define do
  factory :media_item do
    attachment { fixture_file('small.png', 'image/png') }

    association :user
    association :tenant
  end
end
