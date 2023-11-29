# frozen_string_literal: true

class API::V2::QuizAnswerSerializer < API::V2::ApplicationSerializer
  set_type :answer

  belongs_to :question, id_method_name: :quiz_question_id

  attributes :text, :correct
end
