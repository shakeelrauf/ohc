# frozen_string_literal: true

FactoryBot.define do
  factory :score do
    value { rand(1..100) }

    user { create(:child) }

    for_quiz_question

    trait :for_theme do
      scope { create(:theme) }
    end

    trait :for_quiz_question do
      scope { create(:quiz_question) }
    end
  end
end
