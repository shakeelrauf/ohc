# frozen_string_literal: true

class Event < ApplicationRecord
  MAX_FILE_SIZE = 20.megabytes

  include HasSlug
  include Streaming::Credentials
  include TenantResource

  attr_accessor :skip_chat_attribute_validation

  belongs_to :admin, class_name: 'User::Admin'

  scope :active, -> { where(active: true) }
  scope :present, -> { where(status: %w[closed started open]) }

  has_many :targets, dependent: :destroy

  has_one :stream, dependent: :restrict_with_error
  has_one_attached :thumbnail

  # Closed = A stream in future that has yet to start
  # Started = A stream thats running in AWS so the user can setup OBS but not public
  # Open = A stream thats running and available to the public
  # Finished = A stream thats already happened and is available in past events
  enum status: { closed: 'closed', started: 'started', open: 'open', finished: 'finished' }

  validates :ends_at, :key, :name, :starts_at, presence: true
  validates :thumbnail, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: MAX_FILE_SIZE }
  validates :chat_guid, presence: true, unless: :skip_chat_attribute_validation

  before_validation :generate_stream_key

  def self.total_duration
    finished.where('started_at > ?', Time.current.beginning_of_month)
            .sum('TIMESTAMPDIFF(SECOND, started_at, ended_at)')
  end

  def kind
    type.demodulize.gsub('Event', '')
  end

  def path_name
    "#{id}-#{slug}"
  end

  def public?
    open? || finished?
  end

  def url
    "https://#{container_id}.data.mediastore.#{region_name}.amazonaws.com/#{path_name}/main.m3u8"
  end

  def start!
    if finished?
      errors.add(:base, :already_closed)
      return false
    end

    if tenant.streams.count >= tenant.max_streams
      errors.add(:base, :over_max)
      return false
    end

    unless (stream_to_allocate = Stream.next_available)
      errors.add(:base, :none_available)
      return false
    end

    transaction do
      self.stream = stream_to_allocate
      self.started_at = Time.current
      stream_to_allocate.start!
      started!
    end
  end

  def stop!
    transaction do
      stream.stop!
      self.stream = nil
      self.active = false
      self.ended_at = Time.current

      finished!
    end

    check_quotas

    true
  end

  def can_be_deleted?
    closed?
  end

  private

  def generate_stream_key
    return if key.present?

    self.key = SecureRandom.hex(20)
  end

  def check_quotas
    return if tenant.max_stream_hours_percentage < Tenant::STREAM_WARNING_PERCENTAGE

    TenantMailer.warning(tenant).deliver_later
  end
end
