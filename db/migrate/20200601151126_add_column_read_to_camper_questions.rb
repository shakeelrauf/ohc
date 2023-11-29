# frozen_string_literal: true

class AddColumnReadToCamperQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :camper_questions, :read, :boolean, default: false
  end
end
