# frozen_string_literal: true

class AddCampLocationIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :users, :camp_location, index: true
  end
end
