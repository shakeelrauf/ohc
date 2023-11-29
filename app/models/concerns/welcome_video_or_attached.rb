# frozen_string_literal: true

module WelcomeVideoOrAttached
  extend ActiveSupport::Concern

  included do
    MAX_FILE_SIZE = 20.megabytes

    belongs_to :welcome_video, optional: true

    has_one_attached :video

    validates :video, attached: true, content_type: 'video/mp4', size: { less_than: MAX_FILE_SIZE }
  end

  def video
    welcome_video_id.present? ? welcome_video.video : super
  end
end
