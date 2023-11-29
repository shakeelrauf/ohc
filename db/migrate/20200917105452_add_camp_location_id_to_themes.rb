# frozen_string_literal: true

class AddCampLocationIdToThemes < ActiveRecord::Migration[6.0]
  def change
    add_reference :themes, :camp_location
  end
end
