# frozen_string_literal: true

class AddTableUserTokens < ActiveRecord::Migration[6.0]
  def up
    create_table :user_tokens do |t|
      t.string :type
      t.string :token
      t.string :ip_address
      t.string :user_agent
      t.index %i[user_id type updated_at]

      t.references :user

      t.timestamps
    end

    User.transaction do
      # Session Tokens
      User.where.not(authentication_token: nil).each do |user|
        user.create_api_session_token(token: user.authentication_token,
                                      ip_address: user.current_sign_in_ip,
                                      updated_at: user.updated_at)
      end

      # Password Reset Tokens
      User.where.not(reset_token: nil).each do |user|
        user.create_password_reset_token(token: user.reset_token,
                                         ip_address: user.current_sign_in_ip,
                                         updated_at: user.updated_at)
      end
    end

    remove_column :users, :authentication_token, :string
    remove_column :users, :reset_token, :string
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_ip, :string
    remove_column :users, :current_sign_in_ip, :string
    remove_column :users, :sign_in_count, :integer, default: 0
  end

  def down
    drop_table :user_tokens

    add_column :users, :authentication_token, :string
    add_column :users, :reset_token, :string
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :sign_in_count, :integer, default: 0
  end
end
