# frozen_string_literal: true

FactoryBot.define do
  factory :camp do
    name { generate(:string) }
    video { fixture_file('fixture.mp4', 'video/mp4') }

    season

    with_chat_guid

    trait :with_cabins do
      transient do
        cabin_count { 1 }
      end

      cabins { create_list(:cabin, cabin_count) }
    end

    trait :with_chat_guid do
      after(:build) do |camp|
        camp.chat_guid = Interactions::BaseInteractions::Creation.generate_uid(camp.name)
      end
    end
  end
end
