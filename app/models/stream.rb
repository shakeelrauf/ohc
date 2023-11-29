# frozen_string_literal: true

class Stream < ApplicationRecord
  include HasSlug

  IDLE_STATE = 'IDLE'.freeze

  scope :allocated, -> { where.not(event_id: nil) }
  scope :unallocated, -> { where(event_id: nil) }

  belongs_to :event, optional: true

  validates :name, presence: true

  before_create :create_media_live_input
  before_create :create_media_live_channel

  before_destroy :delete_media_live_channel
  before_destroy :delete_media_live_input

  def self.next_available(excluded_ids = [])
    stream = unallocated.where.not(id: excluded_ids)
                        .order('rand()')
                        .first

    return nil unless stream

    return stream if stream.idle?

    # If we've got to this point then we found a stream but it wasnt idle, so check again excluding the one
    # we just found.
    next_available(excluded_ids + [stream.id])
  end

  def input_url
    input.destinations.first.url.gsub("/#{key}", '')
  end

  def key
    event&.key || SecureRandom.hex(20)
  end

  def path_name
    event&.path_name || "#{id}-#{slug}"
  end

  def start!
    Streaming::SetMediaLiveInputDestinations.new(aws_input_id, key).execute
    Streaming::SetMediaLiveChannelDestinations.new(aws_channel_id, path_name).execute
    Streaming::StartMediaLiveChannel.new(aws_channel_id).execute
  end

  def stop!
    Streaming::StopMediaLiveChannel.new(aws_channel_id).execute
  end

  def input
    @input ||= Streaming::DescribeMediaLiveInput.new(aws_input_id).execute
  end

  def channel
    @channel ||= Streaming::DescribeMediaLiveChannel.new(aws_channel_id).execute
  end

  def idle?
    channel.state == IDLE_STATE
  end

  private

  def create_media_live_input
    input_builder = Streaming::CreateMediaLiveInput.new(name, key).execute

    self.aws_input_id = input_builder.input.id
  rescue Aws::MediaLive::Errors::TooManyRequestsException => error
    errors.add(:base, error.message)

    raise ActiveRecord::RecordInvalid, self
  end

  def delete_media_live_input
    DeleteMediaLiveInputJob.perform_later(aws_input_id)
  end

  def create_media_live_channel
    channel_builder = Streaming::CreateMediaLiveChannel.new(name, aws_input_id).execute

    self.aws_channel_id = channel_builder.channel.id
  rescue Aws::MediaLive::Errors::TooManyRequestsException => error
    errors.add(:base, error.message)

    raise ActiveRecord::RecordInvalid, self
  end

  def delete_media_live_channel
    DeleteMediaLiveChannelJob.perform_later(aws_channel_id)
  end
end
