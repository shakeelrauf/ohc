# frozen_string_literal: true

class CreateCustomLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :custom_labels do |t|
      t.string :class_name
      t.string :singular
      t.string :plural
      t.references :tenant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
