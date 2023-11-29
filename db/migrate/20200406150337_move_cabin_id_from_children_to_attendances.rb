# frozen_string_literal: true

class MoveCabinIdFromChildrenToAttendances < ActiveRecord::Migration[6.0]
  def change
    remove_belongs_to :users, :cabin
    add_belongs_to :attendances, :cabin
  end
end
