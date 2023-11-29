# frozen_string_literal: true

FactoryBot.define do
  factory :national_event, class: 'Event::NationalEvent', parent: :event do
    trait :with_targets do
      # INFO: Nothing for national events but required to make tests cleaner.
    end
  end
end
