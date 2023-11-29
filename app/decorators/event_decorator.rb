# frozen_string_literal: true

class EventDecorator < BaseDecorator
  def push_notification_body
    started? ? push_notification_body_starting : push_notification_body_reminder
  end

  def push_notification_body_starting
    I18n.t('push_notifications.event.starting', name: name)
  end

  def push_notification_body_reminder
    I18n.t('push_notifications.event.reminder', name: name, day: starts_at_day, time: starts_at_time)
  end

  def push_notification_title
    I18n.t('push_notifications.event.title')
  end

  private

  def starts_at_day
    starts_at_in_time_zone.strftime('%A')
  end

  def starts_at_time
    # NOTE: %l is padded with a space when its single digits so we need to remove it.
    starts_at_in_time_zone.strftime('%l:%M %p').strip
  end

  def starts_at_in_time_zone
    starts_at.in_time_zone(Rails.application.config.time_zone)
  end
end
