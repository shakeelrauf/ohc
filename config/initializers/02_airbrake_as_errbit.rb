# frozen_string_literal: true

require_relative './01_filter_parameter_logging'

# Configure Errbit exception monitoring service
Airbrake.configure do |config|
  config.host = 'REDACTED'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = 'REDACTED'

  # Disable services errbit doesnt support
  config.job_stats = false
  config.query_stats = false
  config.performance_stats = false

  # Filter out sensitive parameters from those log when an exception occurs
  config.blocklist_keys = Rails.application.config.filter_parameters

  config.environment = Rails.configuration.error_environment

  config.ignore_environments = %w[development test]
end
