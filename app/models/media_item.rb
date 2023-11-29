# frozen_string_literal: true

class MediaItem < ApplicationRecord
  MAX_FILE_SIZE = 300.megabytes

  include TenantResource

  belongs_to :camp, optional: true
  belongs_to :user

  scope :active, -> { where(active: true) }

  has_one_attached :attachment

  validates :attachment, attached: true,
                         content_type: %w[image/png image/jpg image/jpeg video/mp4],
                         size: { less_than: MAX_FILE_SIZE }
end
