# frozen_string_literal: true

class RenameUserRolesToAdminRoles < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_roles, :admin_roles
  end
end
