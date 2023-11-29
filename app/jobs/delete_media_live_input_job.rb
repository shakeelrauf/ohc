# frozen_string_literal: true

require 'aws-sdk-medialive'

class DeleteMediaLiveInputJob < ApplicationJob
  queue_as :media_live

  # This job will fail until the channel has been successfully deleted. Unfortunately this takes a minute or so
  # so we rescue the error and keep retrying.
  retry_on Aws::MediaLive::Errors::ConflictException, wait: 30.seconds

  def perform(aws_input_id)
    Streaming::DeleteMediaLiveInput.new(aws_input_id).execute
  end
end
