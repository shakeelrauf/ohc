# frozen_string_literal: true

class CreateCampLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :camp_locations do |t|
      t.string :name

      t.timestamps
    end

    change_table :seasons do |t|
      t.belongs_to :camp_location
    end
  end
end
