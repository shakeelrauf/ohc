# frozen_string_literal: true

class RemoveMycampSpecificsFromTenants < ActiveRecord::Migration[6.0]
  def change
    remove_column :tenants, :layout, :string
    remove_column :tenants, :domain, :string
    remove_column :tenants, :email_from, :string
    remove_column :tenants, :firebase_server_key, :string
  end
end
