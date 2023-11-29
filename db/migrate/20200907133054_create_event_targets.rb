# frozen_string_literal: true

class CreateEventTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :event_targets do |t|
      t.references :event
      t.references :target, polymorphic: true

      t.timestamps
    end
  end
end
