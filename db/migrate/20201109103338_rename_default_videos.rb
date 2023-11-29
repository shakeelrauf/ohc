# frozen_string_literal: true

class RenameDefaultVideos < ActiveRecord::Migration[6.0]
  def change
    rename_table :default_videos, :welcome_videos
    rename_column :cabins, :default_video_id, :welcome_video_id
    rename_column :camps, :default_video_id, :welcome_video_id
  end
end
