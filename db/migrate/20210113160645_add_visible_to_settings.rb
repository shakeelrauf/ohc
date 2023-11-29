# frozen_string_literal: true

class AddVisibleToSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :visible, :boolean, default: false
  end
end
