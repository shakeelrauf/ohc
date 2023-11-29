# frozen_string_literal: true

class AddIdentifierColumns < ActiveRecord::Migration[6.0]
  def up
    add_column :events, :slug, :string
    add_column :streams, :slug, :string

    Event.find_each do |event|
      event.send(:generate_slug)
      event.save
    end

    Stream.find_each do |stream|
      stream.send(:generate_slug)
      stream.save
    end
  end

  def down
    remove_column :events, :slug
    remove_column :streams, :slug
  end
end
