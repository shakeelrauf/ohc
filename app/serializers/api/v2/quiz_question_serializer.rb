# frozen_string_literal: true

class API::V2::QuizQuestionSerializer < API::V2::ApplicationSerializer
  set_type :quiz_question

  has_many :answers, serializer: API::V2::QuizAnswerSerializer

  attributes :text
end
