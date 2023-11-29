# frozen_string_literal: true

class CreateContactEmailMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_email_messages do |t|
      t.text :text
      t.string :identifier
      t.references :user

      t.timestamps
    end
  end
end
