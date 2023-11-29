# frozen_string_literal: true

Rails.application.routes.default_url_options[:host] = Rails.application.secrets.site_url
