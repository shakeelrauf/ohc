# frozen_string_literal: true

class AddActiveToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :active, :boolean, default: true
  end
end
