# frozen_string_literal: true

class EventMailer < ApplicationMailer
  MAX_DURATION = 180

  def warning(event, duration)
    @event = event
    @duration = duration
    @max_duration = MAX_DURATION

    mail(to: event.admin&.email,
         bcc: Setting.alert_email_addresses,
         subject: default_i18n_subject(name: @event.name, tenant: @event.tenant.name))
  end

  def stopped(event, duration)
    @event = event
    @duration = duration
    @max_duration = MAX_DURATION

    mail(to: event.admin&.email,
         bcc: Setting.alert_email_addresses,
         subject: default_i18n_subject(name: @event.name, tenant: @event.tenant.name))
  end
end
