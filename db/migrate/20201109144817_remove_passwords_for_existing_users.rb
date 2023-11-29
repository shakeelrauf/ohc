# frozen_string_literal: true

class RemovePasswordsForExistingUsers < ActiveRecord::Migration[6.0]
  def up
    # NOTE: Any users in 'limbo' with a password but no username need setting back to unregistered users
    User::Child.where(username: nil).where.not(password_digest: nil).each do |user|
      user.update_columns(password_digest: nil)
    end
  end

  def down; end
end
