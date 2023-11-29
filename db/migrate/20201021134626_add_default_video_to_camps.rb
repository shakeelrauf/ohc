# frozen_string_literal: true

class AddDefaultVideoToCamps < ActiveRecord::Migration[6.0]
  def change
    add_reference :camps, :default_video
  end
end
