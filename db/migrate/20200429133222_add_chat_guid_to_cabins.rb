# frozen_string_literal: true

class AddChatGuidToCabins < ActiveRecord::Migration[6.0]
  def change
    change_table :cabins do |t|
      t.string :chat_guid, index: true
    end
  end
end
