# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    name { "#{generate(:string)} Season" }

    camp_location

    trait :with_camps do
      camp_location { create(:camp_location) }
      camps { create_list(:camp, 2, camp_location: camp_location) }
    end

    trait :with_camps_and_cabins do
      camp_location { create(:camp_location) }
      camps { create_list(:camp, 2, :with_cabins, camp_location: camp_location) }
    end
  end
end
