# frozen_string_literal: true

class ChangeUserReferencesToAdmin < ActiveRecord::Migration[6.0]
  def change
    change_table :camps do |t|
      t.remove_references :user

      t.belongs_to :admin, index: true
    end

    change_table :user_roles do |t|
      t.remove_references :user

      t.belongs_to :admin, index: true
    end
  end
end
