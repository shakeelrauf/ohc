# frozen_string_literal: true

class AddGenderToCabin < ActiveRecord::Migration[6.0]
  def change
    add_column :cabins, :gender, :string
  end
end
