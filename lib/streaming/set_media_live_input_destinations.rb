# frozen_string_literal: true

module Streaming
  class SetMediaLiveInputDestinations < MediaLive
    def initialize(input_id, key)
      @input_id = input_id
      @key = key
    end

    def execute
      update_destinations
    end

    private

    def update_destinations
      client.update_input(
        input_id: @input_id,
        destinations: [
          { stream_name: "stream/#{@key}" }
        ]
      )
    end
  end
end
