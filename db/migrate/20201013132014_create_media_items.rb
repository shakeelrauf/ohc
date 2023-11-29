# frozen_string_literal: true

class CreateMediaItems < ActiveRecord::Migration[6.0]
  def change
    create_table :media_items do |t|
      t.references :camp
      t.references :user, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
