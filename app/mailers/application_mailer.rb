# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.email[:from_address],
          reply_to: Rails.application.secrets.email[:from_address]

  layout 'mailer'

  add_template_helper(ApplicationHelper)
end
