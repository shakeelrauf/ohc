# frozen_string_literal: true

class AddChatGuidToEvents < ActiveRecord::Migration[6.0]
  def change
    change_table :events do |t|
      t.string :chat_guid, index: true
    end
  end
end
