# frozen_string_literal: true

class API::V2::ConversationSerializer < API::V2::ApplicationSerializer
  set_type :conversation

  has_one :conversation_with, serializer: API::V2::UserSerializer, record_type: :user

  attributes :id,
             :created_at,
             :receiver_type,
             :unread_message_count,
             :updated_at
end
