# frozen_string_literal: true

class AddLayoutFieldsToTenant < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :layout, :string
    add_column :tenants, :domain, :string
    add_column :tenants, :email_from, :string
  end
end
