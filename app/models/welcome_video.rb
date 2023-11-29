# frozen_string_literal: true

class WelcomeVideo < ApplicationRecord
  MAX_FILE_SIZE = 20.megabytes

  include TenantResource

  has_many :camps, dependent: :restrict_with_error
  has_many :cabins, dependent: :restrict_with_error

  scope :active, -> { where(active: true) }

  has_one_attached :video

  validates :name, presence: true
  validates :video, attached: true, content_type: 'video/mp4', size: { less_than: MAX_FILE_SIZE }

  def can_be_deleted?
    camps.none? && cabins.none?
  end
end
