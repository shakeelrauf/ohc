# frozen_string_literal: true

module Streaming
  class DescribeMediaLiveChannel < MediaLive
    def initialize(channel_id)
      @channel_id = channel_id
    end

    def execute
      describe_channel
    end

    private

    def describe_channel
      client.describe_channel(
        channel_id: @channel_id
      )
    end
  end
end
