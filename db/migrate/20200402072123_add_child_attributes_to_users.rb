# frozen_string_literal: true

class AddChildAttributesToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.date :date_of_birth
      t.string :gender
    end
  end
end
