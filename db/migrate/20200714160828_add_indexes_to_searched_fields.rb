# frozen_string_literal: true

class AddIndexesToSearchedFields < ActiveRecord::Migration[6.0]
  def change
    add_index :attendances, :code
    add_index :users, :first_name
    add_index :users, :last_name
  end
end
