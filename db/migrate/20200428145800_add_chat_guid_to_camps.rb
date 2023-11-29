# frozen_string_literal: true

class AddChatGuidToCamps < ActiveRecord::Migration[6.0]
  def change
    change_table :camps do |t|
      t.string :chat_guid, index: true
    end
  end
end
