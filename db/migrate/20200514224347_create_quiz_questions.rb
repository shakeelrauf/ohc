# frozen_string_literal: true

class CreateQuizQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :quiz_questions do |t|
      t.string :text
      t.references :theme

      t.timestamps
    end

    create_table :quiz_answers do |t|
      t.string :text
      t.boolean :correct, default: false

      t.references :quiz_question

      t.timestamps
    end
  end
end
