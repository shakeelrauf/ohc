# frozen_string_literal: true

FactoryBot.define do
  factory :camp_event, class: 'Event::CampEvent', parent: :event do
    trait :with_targets do
      transient do
        target_count { 1 }
      end

      camps { create_list(:camp, target_count) }
    end
  end
end
