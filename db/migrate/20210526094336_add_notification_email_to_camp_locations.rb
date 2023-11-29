# frozen_string_literal: true

class AddNotificationEmailToCampLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :camp_locations, :notification_email, :string
  end
end
