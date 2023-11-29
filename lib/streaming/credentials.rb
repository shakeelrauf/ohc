# frozen_string_literal: true

module Streaming
  module Credentials
    extend ActiveSupport::Concern

    private

    def config
      @config ||= Rails.application.secrets.media_live
    end

    def credentials
      @credentials ||= Aws::Credentials.new(config[:access_key], config[:secret_key])
    end

    def account_id
      config[:account_id]
    end

    def container_id
      config[:container_id]
    end

    def region_name
      config[:region]
    end

    def security_group_id
      config[:security_group_id]
    end
  end
end
