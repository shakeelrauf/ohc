# frozen_string_literal: true

FactoryBot.define do
  factory :contact_email_message do
    identifier { generate(:string) }
    text { generate(:string) }

    association :tenant
  end
end
