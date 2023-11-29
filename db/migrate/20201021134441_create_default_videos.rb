# frozen_string_literal: true

class CreateDefaultVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :default_videos do |t|
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
