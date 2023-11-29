# frozen_string_literal: true

class AddTypeToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :type, :string, index: true
  end
end
