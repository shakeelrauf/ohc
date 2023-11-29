# frozen_string_literal: true

class TenantMailer < ApplicationMailer
  default to: -> { Setting.alert_email_addresses }

  def warning(tenant)
    @tenant = TenantDecorator.decorate(tenant)

    mail(subject: default_i18n_subject(name: @tenant.name))
  end
end
