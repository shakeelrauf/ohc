# frozen_string_literal: true

class Tenant < ApplicationRecord
  MAX_FILE_SIZE = 20.megabytes
  STREAM_WARNING_PERCENTAGE = 90
  CUSTOM_LABEL_FIELDS = {
    camp_label: 'Camp',
    camp_location_label: 'CampLocation',
    event_cabin_event_label: 'Event::CabinEvent',
    event_camp_event_label: 'Event::CampEvent',
    event_national_event_label: 'Event::NationalEvent',
    media_item_camp_media_item_label: 'MediaItem::CampMediaItem',
    media_item_national_media_item_label: 'MediaItem::NationalMediaItem',
    user_child_label: 'User::Child',
    season_label: 'Season'
  }.freeze

  belongs_to :color_theme

  has_many :camp_locations, dependent: :restrict_with_error
  has_many :camper_questions, dependent: :restrict_with_error
  has_many :contact_email_messages, dependent: :restrict_with_error
  has_many :custom_labels, dependent: :destroy
  has_many :events, dependent: :restrict_with_error
  has_many :imports, dependent: :destroy
  has_many :media_items, dependent: :restrict_with_error
  has_many :themes, dependent: :restrict_with_error
  has_many :users, dependent: :restrict_with_error
  has_many :welcome_videos, dependent: :restrict_with_error

  has_many :admins, class_name: 'User::Admin'
  has_many :children, class_name: 'User::Child'

  has_one_attached :logo

  accepts_nested_attributes_for :custom_labels, reject_if: proc { |attributes| attributes['singular'].blank? && attributes['plural'].blank? && attributes['id'].blank? }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :logo, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: MAX_FILE_SIZE }
  validates :max_users, :max_streams, :max_stream_hours, numericality: { only_integer: true, greater_than: 0, less_than: 1_000_000 }, presence: true

  def streams
    Stream.where(event_id: event_ids)
  end

  def streams_available
    max_streams - streams.count
  end

  def total_duration_in_hours
    (events.total_duration.to_d / 60 / 60)
  end

  def max_stream_seconds
    max_stream_hours * 60 * 60
  end

  def max_users_percentage
    (users.count.to_f / max_users) * 100
  end

  def max_streams_percentage
    (streams.count.to_f / max_streams) * 100
  end

  def max_stream_hours_percentage
    (total_duration_in_hours.to_f / max_stream_hours) * 100
  end

  def can_be_deleted?
    users.none? && camp_locations.none?
  end

  def initialize_custom_labels
    I18n.available_locales.each do |locale|
      CustomLabel::CLASSES.each do |class_name|
        custom_labels.find_or_initialize_by(class_name: class_name, locale: locale)
      end
    end
  end
end
