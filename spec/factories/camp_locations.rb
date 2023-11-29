# frozen_string_literal: true

FactoryBot.define do
  factory :camp_location do
    name { "Camp Location #{generate(:string)}" }
    notification_email { 'an@example.com' }

    association :tenant
  end
end
