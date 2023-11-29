# frozen_string_literal: true

class QuizAnswer < ApplicationRecord
  belongs_to :question, class_name: 'QuizQuestion', inverse_of: :answers, foreign_key: 'quiz_question_id'

  validates :text, presence: true, length: { maximum: 30 }
  validates :correct, inclusion: { in: [true, false] }
end
