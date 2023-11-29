# frozen_string_literal: true

require 'aws-sdk-medialive'

module Streaming
  class CreateMediaLiveChannel < MediaLive
    attr_accessor :name, :input_id

    def initialize(name, input_id)
      self.name = name.parameterize
      self.input_id = input_id
    end

    def execute
      create_channel
    end

    private

    def create_channel(config_file = 'default_channel.json')
      file = File.read(Rails.root.join('lib', 'streaming', 'configs', config_file))
      path_name = name.parameterize

      channel_config = JSON.parse(file).deep_transform_keys(&:to_sym)
      channel_config[:name] = name
      channel_config[:input_attachments][0][:input_id] = input_id
      channel_config[:destinations][0][:settings][0][:url] = "mediastoressl://#{container_id}.data.mediastore.#{region_name}.amazonaws.com/#{path_name}/main"
      channel_config[:role_arn] = "arn:aws:iam::#{account_id}:role/MediaLiveAccessRole"

      client.create_channel(channel_config)
    end
  end
end
