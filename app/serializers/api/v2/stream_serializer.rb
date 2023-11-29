# frozen_string_literal: true

class API::V2::StreamSerializer < API::V2::ApplicationSerializer
  attributes :key, :input_url, :slug

  attribute :status do |object|
    object.channel&.state
  end
end
