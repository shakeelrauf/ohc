# frozen_string_literal: true

class API::V2::Event::PushNotificationSerializer < API::V2::ApplicationSerializer
  set_type :push_notification

  belongs_to :event

  attributes :title, :body
end
