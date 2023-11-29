# frozen_string_literal: true

class API::V2::ThemeSerializer < API::V2::ApplicationSerializer
  set_type :theme

  has_many :quiz_questions, serializer: API::V2::QuizQuestionSerializer

  attributes :name
end
