# frozen_string_literal: true

module Streaming
  class DeleteMediaLiveChannel < MediaLive
    def initialize(channel_id)
      @channel_id = channel_id
    end

    def execute
      delete_channel
    end

    private

    def delete_channel
      client.delete_channel(
        channel_id: @channel_id
      )
    end
  end
end
