# frozen_string_literal: true

class RemoveLeaderIdColumnsFromCampAndCabin < ActiveRecord::Migration[6.0]
  def up
    remove_column :camps, :leader_id
    remove_column :cabins, :leader_id
  end

  def down
    add_column :camps, :leader_id, :integer
    add_index :camps, :leader_id

    add_column :cabins, :leader_id, :integer
    add_index :cabins, :leader_id
  end
end
