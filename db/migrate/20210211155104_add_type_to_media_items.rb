# frozen_string_literal: true

class AddTypeToMediaItems < ActiveRecord::Migration[6.0]
  def up
    add_column :media_items, :type, :string

    MediaItem.where(camp_id: nil).update_all(type: MediaItem::NationalMediaItem)
    MediaItem.where.not(camp_id: nil).update_all(type: MediaItem::CampMediaItem)
  end

  def down
    remove_column :media_items, :type
  end
end
