# frozen_string_literal: true

module Streaming
  class StopMediaLiveChannel < MediaLive
    def initialize(channel_id)
      @channel_id = channel_id
    end

    def execute
      stop_channel
    end

    private

    def stop_channel
      client.stop_channel(
        channel_id: @channel_id
      )
    end
  end
end
