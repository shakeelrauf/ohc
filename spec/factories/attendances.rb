# frozen_string_literal: true

FactoryBot.define do
  factory :attendance do
    camp { create(:camp, :with_cabins) }

    by_child

    after(:build) do |attendance|
      attendance.cabin_id = attendance.camp.cabin_ids.first
    end

    trait :by_child do
      association :user, factory: :child
    end

    trait :by_admin do
      association :user, factory: :admin
    end
  end
end
