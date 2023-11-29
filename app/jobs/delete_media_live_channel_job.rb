# frozen_string_literal: true

class DeleteMediaLiveChannelJob < ApplicationJob
  queue_as :media_live

  def perform(aws_channel_id)
    Streaming::DeleteMediaLiveChannel.new(aws_channel_id).execute
  end
end
