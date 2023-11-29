# frozen_string_literal: true

class AddColumnActiveToThemes < ActiveRecord::Migration[6.0]
  def change
    change_table :themes do |t|
      t.boolean :active, default: false, null: false, index: true
    end
  end
end
