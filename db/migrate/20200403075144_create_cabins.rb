# frozen_string_literal: true

class CreateCabins < ActiveRecord::Migration[6.0]
  def change
    create_table :cabins do |t|
      t.belongs_to :admin
      t.belongs_to :camp

      t.string :name

      t.timestamps
    end

    add_belongs_to :users, :cabin
  end
end
