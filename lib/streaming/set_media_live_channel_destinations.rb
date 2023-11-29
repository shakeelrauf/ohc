# frozen_string_literal: true

module Streaming
  class SetMediaLiveChannelDestinations < MediaLive
    def initialize(channel_id, path_name)
      @channel_id = channel_id
      @path_name = path_name
    end

    def execute
      update_destinations
    end

    private

    def update_destinations
      client.update_channel(
        channel_id: @channel_id,
        destinations: [
          {
            id: 'rtmp',
            settings: [{ url: "mediastoressl://#{container_id}.data.mediastore.#{region_name}.amazonaws.com/#{@path_name}/main" }]
          }
        ]
      )
    end
  end
end
