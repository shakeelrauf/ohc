# frozen_string_literal: true

FactoryBot.define do
  factory :cabin_event, class: 'Event::CabinEvent', parent: :event do
    trait :with_targets do
      transient do
        target_count { 1 }
      end

      cabins { create_list(:cabin, target_count) }
    end
  end
end
