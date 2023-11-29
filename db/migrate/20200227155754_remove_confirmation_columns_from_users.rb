# frozen_string_literal: true

class RemoveConfirmationColumnsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :confirmed, :boolean, default: false
    remove_column :users, :confirmation_token, :string
  end
end
