# frozen_string_literal: true

class CreateColorThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :color_themes do |t|
      t.string :name
      t.string :primary_color
      t.string :secondary_color

      t.timestamps
    end
  end
end
