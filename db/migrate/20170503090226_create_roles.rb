# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, index: true

      t.timestamps
    end
  end
end
