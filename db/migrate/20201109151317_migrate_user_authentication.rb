# frozen_string_literal: true

class MigrateUserAuthentication < ActiveRecord::Migration[6.0]
  def up
    User.where.not(password_digest: nil).each do |user|
      username = user.username || user.email.split('@').first

      auth = Authentication.new(password_digest: user.password_digest,
                                username: username)

      # We need to do this to get round password validation as we are setting the digest manually
      auth.save(validate: false)

      user.update_column(:authentication_id, auth.id)
    end
  end

  def down; end
end
