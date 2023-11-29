# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.boolean :confirmed, default: false
      t.string :authentication_token
      t.string :confirmation_token
      t.string :reset_token
      t.datetime :last_sign_in_at
      t.datetime :current_sign_in_at
      t.string :last_sign_in_ip
      t.string :current_sign_in_ip
      t.integer :sign_in_count, default: 0

      t.timestamps
    end
  end
end
