# frozen_string_literal: true

module Streaming
  class DescribeMediaLiveInput < MediaLive
    def initialize(input_id)
      @input_id = input_id
    end

    def execute
      describe_input
    end

    private

    def describe_input
      client.describe_input(
        input_id: @input_id
      )
    end
  end
end
