# frozen_string_literal: true

class AddFirebaseServerKeyToTenants < ActiveRecord::Migration[6.0]
  def change
    add_column :tenants, :firebase_server_key, :string
  end
end
