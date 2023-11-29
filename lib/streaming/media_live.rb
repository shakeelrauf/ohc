# frozen_string_literal: true

require 'aws-sdk-medialive'

module Streaming
  class MediaLive
    include Streaming::Credentials

    private

    def client
      @client ||= Aws::MediaLive::Client.new(
        region: region_name,
        credentials: credentials
      )
    end
  end
end
