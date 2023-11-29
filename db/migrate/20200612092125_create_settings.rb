# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :name, index: { unique: true }
      t.string :value

      t.timestamps
    end
  end
end
