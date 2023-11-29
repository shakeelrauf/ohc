# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OneHopeCanadaAPI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Default time zone
    config.time_zone = Rails.application.secrets.default_time_zone

    # Supported locales
    config.i18n.available_locales = [:en, :fr]

    # Don't generate helpers and assets
    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
    end

    config.autoload_paths << Rails.root.join('lib')

    # Email
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: Rails.application.secrets.email[:host],
      port: Rails.application.secrets.email[:port],
      domain: Rails.application.secrets.email[:domain],
      user_name: Rails.application.secrets.email[:username],
      password: Rails.application.secrets.email[:password],
      authentication: 'plain',
      enable_starttls_auto: true
    }

    # The name of the environment that should be used for reporting errors
    config.error_environment = ENV.fetch('ERROR_ENVIRONMENT') { Rails.env }

    config.active_job.queue_adapter = :sidekiq
  end
end
