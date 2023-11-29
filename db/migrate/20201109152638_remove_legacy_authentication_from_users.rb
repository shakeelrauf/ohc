# frozen_string_literal: true

class RemoveLegacyAuthenticationFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :username, :string
  end
end
