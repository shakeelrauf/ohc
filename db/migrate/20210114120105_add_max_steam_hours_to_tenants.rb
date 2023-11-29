# frozen_string_literal: true

class AddMaxSteamHoursToTenants < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :max_stream_hours, :integer, default: 1
  end
end
