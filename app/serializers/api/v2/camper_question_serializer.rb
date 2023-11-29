# frozen_string_literal: true

class API::V2::CamperQuestionSerializer < API::V2::ApplicationSerializer
  set_type :camper_question

  belongs_to :child, record_type: :child, serializer: API::V2::UserSerializer
  belongs_to :admin, record_type: :admin, serializer: API::V2::UserSerializer

  attributes :text, :reply
end
