# frozen_string_literal: true

class API::V2::ScoreSerializer < API::V2::ApplicationSerializer
  set_type :score

  belongs_to :scope, polymorphic: true
  belongs_to :user

  attributes :value, :scope_id
end
