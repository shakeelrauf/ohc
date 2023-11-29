# frozen_string_literal: true

class API::V2::CabinSerializer < API::V2::ApplicationSerializer
  include Video

  set_type :cabin

  has_many :children, serializer: API::V2::UserSerializer

  attributes :name, :chat_guid, :gender
end
