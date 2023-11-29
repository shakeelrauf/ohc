# frozen_string_literal: true

class AddDescriptionToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :description, :text, after: :name
  end
end