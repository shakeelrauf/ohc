# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_question do
    text { "#{generate(:string)}?" }

    theme

    after(:build) do |object|
      object.answers = build_list(:quiz_answer, 2, question: object)
    end
  end
end
