# frozen_string_literal: true

class AddStartedAtEndedAtToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :started_at, :datetime
    add_column :events, :ended_at, :datetime
  end
end
