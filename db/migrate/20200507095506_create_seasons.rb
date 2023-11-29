# frozen_string_literal: true

class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.string :name
      t.timestamps
    end

    change_table :camps do |t|
      t.belongs_to :season, index: true
    end
  end
end
