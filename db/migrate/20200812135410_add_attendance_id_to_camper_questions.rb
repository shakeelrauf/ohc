# frozen_string_literal: true

class AddAttendanceIdToCamperQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :camper_questions, :attendance
  end
end
