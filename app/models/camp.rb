# frozen_string_literal: true

class Camp < ApplicationRecord
  include Attendances
  include WelcomeVideoOrAttached

  attr_accessor :skip_chat_attribute_validation

  belongs_to :season

  has_one :camp_location, through: :season

  has_many :users, through: :attendances, dependent: :restrict_with_error
  has_many :admins, through: :attendances, class_name: 'User::Admin', source: :user
  has_many :children, through: :attendances, class_name: 'User::Child', source: :user
  has_many :cabins, dependent: :destroy
  has_many :imports, as: :scope
  has_many :media_items, class_name: 'MediaItem::CampMediaItem', dependent: :restrict_with_error

  has_many :targets, class_name: 'Event::Target', as: :target, dependent: :destroy
  has_many :events, through: :targets

  validates :name, presence: true
  validates :chat_guid, presence: true, unless: :skip_chat_attribute_validation

  def can_be_deleted?
    users.empty? && media_items.empty?
  end
end
