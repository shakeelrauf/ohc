# frozen_string_literal: true

class SetCabinOnCabinlessAttendances < ActiveRecord::Migration[6.0]
  def up
    Attendance.where(cabin_id: nil).find_each do |attendance|
      attendance.update(cabin_id: attendance.camp.cabin_ids.first)
    end
  end

  def down; end
end
