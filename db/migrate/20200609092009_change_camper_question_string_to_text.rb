# frozen_string_literal: true

class ChangeCamperQuestionStringToText < ActiveRecord::Migration[6.0]
  def up
    change_column :camper_questions, :text, :text
    change_column :camper_questions, :reply, :text
  end

  def down
    change_column :camper_questions, :text, :string
    change_column :camper_questions, :reply, :string
  end
end
