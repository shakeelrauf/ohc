# frozen_string_literal: true

class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|
      t.integer :value
      t.references :user
      t.references :scope, polymorphic: true

      t.timestamps
    end
  end
end
