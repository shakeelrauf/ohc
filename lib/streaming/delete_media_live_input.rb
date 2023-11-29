# frozen_string_literal: true

module Streaming
  class DeleteMediaLiveInput < MediaLive
    def initialize(input_id)
      @input_id = input_id
    end

    def execute
      delete_input
    end

    private

    def delete_input
      client.delete_input(
        input_id: @input_id
      )
    end
  end
end
