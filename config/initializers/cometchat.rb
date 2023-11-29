# frozen_string_literal: true

Cometchat.configure do |config|
  config.app_id = Rails.application.secrets.cometchat[:app_id]
  config.api_key = Rails.application.secrets.cometchat[:api_key]
  config.endpoint = Rails.application.secrets.cometchat[:endpoint]

  config.debug = Rails.application.secrets.cometchat[:debug]
end
