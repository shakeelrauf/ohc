# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :status, default: 'closed'
      t.references :target, polymorphic: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :admin, null: false

      t.timestamps
    end

    add_reference :streams, :event
  end
end
