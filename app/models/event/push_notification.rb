# frozen_string_literal: true

class Event::PushNotification
  include ActiveModel::Model

  attr_accessor :event, :body, :title

  delegate :id, to: :event

  validates :event, :body, :title, presence: true

  def deliver!
    Firebase::Notification.new(tokens: tokens, title: title, body: body, data: data).execute
  end

  def event_id
    event.id
  end

  private

  def data
    event.closed? ? {} : { eventId: event.id }
  end

  def tokens
    user_ids = if event.is_a?(Event::NationalEvent)
                 User.with_push_notifications.where(tenant_id: event.tenant_id).ids
               else
                 event.targets.collect { |target| target.target.users.with_push_notifications.ids }.flatten
               end

    User.where(id: user_ids)
        .joins(:device_token)
        .where(live_event_notification: true)
        .pluck('device_tokens.token')
  end
end
