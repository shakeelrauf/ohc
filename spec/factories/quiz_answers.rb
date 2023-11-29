# frozen_string_literal: true

FactoryBot.define do
  factory :quiz_answer do
    text { "Answer: #{generate(:string)}" }
    correct { true }

    association :question, factory: :quiz_question
  end
end
