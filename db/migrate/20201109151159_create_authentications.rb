# frozen_string_literal: true

class CreateAuthentications < ActiveRecord::Migration[6.0]
  def change
    create_table :authentications do |t|
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end