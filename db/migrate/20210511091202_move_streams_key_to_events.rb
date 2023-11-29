# frozen_string_literal: true

class MoveStreamsKeyToEvents < ActiveRecord::Migration[6.0]
  def up
    remove_column :streams, :key
    add_column :events, :key, :string

    Event.find_each do |event|
      event.update_column(:key, SecureRandom.hex(20))
    end
  end

  def down
    remove_column :events, :key
    add_column :streams, :key, :string
  end
end
