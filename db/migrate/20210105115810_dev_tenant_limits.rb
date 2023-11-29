# frozen_string_literal: true

class DevTenantLimits < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :max_users, :integer, default: 50
    add_column :tenants, :max_streams, :integer, default: 1
  end
end
