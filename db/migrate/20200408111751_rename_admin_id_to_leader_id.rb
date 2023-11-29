# frozen_string_literal: true

class RenameAdminIdToLeaderId < ActiveRecord::Migration[6.0]
  def change
    rename_column :cabins, :admin_id, :leader_id
    rename_column :camps, :admin_id, :leader_id
  end
end
