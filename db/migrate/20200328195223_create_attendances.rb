# frozen_string_literal: true

class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.string :code

      t.belongs_to :child, index: true
      t.belongs_to :camp, index: true

      t.timestamps
    end
  end
end
