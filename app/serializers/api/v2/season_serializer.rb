# frozen_string_literal: true

class API::V2::SeasonSerializer < API::V2::ApplicationSerializer
  has_many :camps

  attributes :name
end
