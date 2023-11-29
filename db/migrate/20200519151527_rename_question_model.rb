# frozen_string_literal: true

class RenameQuestionModel < ActiveRecord::Migration[6.0]
  # Move questions to camper_questions to reduce confusion with quiz questions
  def change
    rename_table :questions, :camper_questions
  end
end
