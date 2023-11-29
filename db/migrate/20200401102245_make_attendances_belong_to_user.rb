# frozen_string_literal: true

class MakeAttendancesBelongToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :attendances do |t|
      t.remove_references :child

      t.belongs_to :user, index: true
    end
  end
end
