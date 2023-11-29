# frozen_string_literal: true

class PopulateAttendanceIdOnCamperQuestions < ActiveRecord::Migration[6.0]
  def up
    CamperQuestion.find_each do |camper_question|
      attendance = camper_question.child&.attendances&.last

      # We need to skip validation here due to CamperQuestion requiring a reply on update
      camper_question.update_column(:attendance_id, attendance.id) if attendance
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
