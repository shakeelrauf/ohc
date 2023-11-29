# frozen_string_literal: true

class CreateStreams < ActiveRecord::Migration[6.0]
  def change
    create_table :streams do |t|
      t.string :name
      t.string :key
      t.string :aws_input_id
      t.string :aws_channel_id

      t.timestamps
    end
  end
end
