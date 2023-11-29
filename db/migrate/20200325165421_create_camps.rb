# frozen_string_literal: true

class CreateCamps < ActiveRecord::Migration[6.0]
  def change
    create_table :camps do |t|
      t.string :name
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
