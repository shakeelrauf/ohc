# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { generate(:string) }
    starts_at { Time.now - 1.hour }
    ends_at { Time.now + 1.hour }

    association :admin
    association :tenant

    with_chat_guid

    trait :with_chat_guid do
      after(:build) do |event|
        event.chat_guid = Interactions::BaseInteractions::Creation.generate_uid("#{event.chat_guid}_#{event.name}")
      end
    end

    trait :with_thumbnail do
      thumbnail { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'small.png'), 'image/png') }
    end

    trait :with_started do
      after(:build) do |event|
        event.start!
      end
    end
  end
end
