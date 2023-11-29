# frozen_string_literal: true

FactoryBot.define do
  factory :camper_question do
    text { generate(:string) }

    association :child
    association :tenant

    after(:build) do |camper_question|
      camper_question.attendance = create(:attendance, user: camper_question.child) unless camper_question.attendance
    end

    trait :with_reply do
      reply { "This is because #{generate(:string)}" }
    end
  end
end
