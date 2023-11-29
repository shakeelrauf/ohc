# frozen_string_literal: true

module Streaming
  class StartMediaLiveChannel < MediaLive
    def initialize(channel_id)
      @channel_id = channel_id
    end

    def execute
      start_channel
    end

    private

    def start_channel
      client.start_channel(
        channel_id: @channel_id
      )
    end
  end
end
