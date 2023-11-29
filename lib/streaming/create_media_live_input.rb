# frozen_string_literal: true

require 'aws-sdk-medialive'

module Streaming
  class CreateMediaLiveInput < MediaLive
    attr_accessor :name, :key

    def initialize(name, key)
      self.name = name.parameterize
      self.key = key
    end

    def execute
      create_input
    end

    private

    def create_input
      client.create_input(
        destinations: [
          { stream_name: "stream/#{key}" }
        ],
        name: name,
        input_security_groups: [security_group_id],
        sources: [],
        type: 'RTMP_PUSH'
      )
    end
  end
end
