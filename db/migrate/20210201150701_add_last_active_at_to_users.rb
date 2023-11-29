# frozen_string_literal: true

class AddLastActiveAtToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :last_active_at, :datetime

    User.find_each do |user|
      user.last_active_at = user.authentication&.api_session_token&.updated_at
      user.save(validate: false)
    end
  end

  def down
    remove_column :users, :last_active_at
  end
end
