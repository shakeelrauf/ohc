# frozen_string_literal: true

class AddDefaultVideoToCabins < ActiveRecord::Migration[6.0]
  def change
    add_reference :cabins, :default_video
  end
end
