# frozen_string_literal: true

class API::V2::UserSessionSerializer < API::V2::UserSerializer
  set_type :user

  attributes :chat_uid,
             :chat_auth_token,
             :live_event_notification
end
