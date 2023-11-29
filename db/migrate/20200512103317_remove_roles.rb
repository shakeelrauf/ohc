# frozen_string_literal: true

class RemoveRoles < ActiveRecord::Migration[6.0]
  def change
    drop_table :roles do |t|
      t.string 'name'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['name'], name: 'index_roles_on_name'
    end

    drop_table :admin_roles do |t|
      t.integer 'role_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'admin_id'
      t.index ['admin_id'], name: 'index_admin_roles_on_admin_id'
      t.index ['role_id'], name: 'index_admin_roles_on_role_id'
    end
  end
end
