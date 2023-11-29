# frozen_string_literal: true

FactoryBot.define do
  factory :cabin do
    name { generate(:string) }
    gender { %w[male female].sample }
    video { fixture_file('fixture.mp4', 'video/mp4') }

    camp

    with_chat_guid

    trait :with_chat_guid do
      after(:build) do |cabin|
        cabin.chat_guid = Interactions::BaseInteractions::Creation.generate_uid("#{cabin.camp.chat_guid}_#{cabin.name}")
      end
    end
  end
end
