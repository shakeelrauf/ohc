# frozen_string_literal: true

class ReworkUserTokens < ActiveRecord::Migration[6.0]
  def up
    rename_table :user_tokens, :authentication_tokens
    add_reference :authentication_tokens, :authentication

    Authentication::Token.where(type: 'User::Token::APISession').update_all(type: 'Authentication::Token::APISession')
    Authentication::Token.where(type: 'User::Token::PasswordReset').update_all(type: 'Authentication::Token::PasswordReset')
    Authentication::Token.where(type: 'User::Token::WebSession').update_all(type: 'Authentication::Token::WebSession')

    Authentication::Token.find_each do |token|
      user = User.find(token.user_id)

      token.authentication = user.authentication
      token.save
    end

    remove_reference :authentication_tokens, :user
  end

  def down
    rename_table :authentication_tokens, :user_tokens
    add_reference :user_tokens, :user
    remove_reference :user_tokens, :authentication
  end
end
