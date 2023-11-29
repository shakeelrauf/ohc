# frozen_string_literal: true

class CreateDeviceTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :device_tokens do |t|
      t.string :token
      t.string :device_operating_system

      t.timestamps
    end

    add_belongs_to :users, :device_token, index: true
  end
end
