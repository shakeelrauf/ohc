# frozen_string_literal: true

class Cabin < ApplicationRecord
  include Attendances
  include WelcomeVideoOrAttached

  attr_accessor :skip_chat_attribute_validation

  enum gender: { mixed: 'mixed', female: 'female', male: 'male' }

  belongs_to :camp

  has_one :camp_location, through: :camp

  has_many :admins, through: :attendances, class_name: 'User::Admin', source: :user
  has_many :children, through: :attendances, class_name: 'User::Child', source: :user
  has_many :users, through: :attendances

  has_many :targets, class_name: 'Event::Target', as: :target, dependent: :destroy
  has_many :events, through: :targets

  has_many :imports, as: :scope, dependent: :destroy

  validates :name, presence: true
  validates :chat_guid, presence: true, unless: :skip_chat_attribute_validation

  def can_be_deleted?
    attendances.none?
  end
end
