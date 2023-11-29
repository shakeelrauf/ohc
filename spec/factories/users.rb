# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { generate(:email) }
    first_name { generate(:string) }
    last_name { generate(:string) }
    gender { User.genders.values.sample }
    date_of_birth { rand(12.years.ago..8.years.ago) }
    live_event_notification { true }

    with_chat_attributes

    association :authentication
    association :tenant

    trait :without_chat_attributes do
      after(:build) do |user|
        user.chat_uid = nil
        user.chat_auth_token = nil
      end
    end

    trait :with_chat_attributes do
      after(:build) do |user|
        user.chat_uid ||= Interactions::BaseInteractions::Creation.generate_uid(user.full_name)
        user.chat_auth_token ||= "CHAT_AUTH_TOKEN_#{generate(:string)}"
      end
    end
  end
end
