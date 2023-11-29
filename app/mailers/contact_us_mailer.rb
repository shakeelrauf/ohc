# frozen_string_literal: true

class ContactUsMailer < ApplicationMailer
  default to: -> { Setting.contact_email_addresses }

  def contact_us(email, user)
    @user = user
    @text = email.text

    mail(subject: default_i18n_subject(identifier: email.identifier))
  end
end
