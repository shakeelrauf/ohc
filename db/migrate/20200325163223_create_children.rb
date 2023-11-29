# frozen_string_literal: true

class CreateChildren < ActiveRecord::Migration[6.0]
  def change
    create_table :children do |t|
      t.string :name
      t.string :gender
      t.string :parent_email
      t.date :date_of_birth
      t.string :password_digest

      t.timestamps
    end
  end
end