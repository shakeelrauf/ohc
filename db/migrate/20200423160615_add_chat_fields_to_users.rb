# frozen_string_literal: true

class AddChatFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :chat_uid, index: true
      t.string :chat_auth_token
    end
  end
end
