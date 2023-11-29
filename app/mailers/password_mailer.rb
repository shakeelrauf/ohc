# frozen_string_literal: true

class PasswordMailer < ApplicationMailer
  def reset_multiple(sender, email, registered, unregistered)
    @registered = registered
    @unregistered = unregistered

    mail(to: email, from: sender)
  end
end
