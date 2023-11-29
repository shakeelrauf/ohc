# frozen_string_literal: true

class QuizQuestion < ApplicationRecord
  belongs_to :theme

  has_many :answers, class_name: 'QuizAnswer', inverse_of: :question, dependent: :destroy
  has_many :scores, as: :scope, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  validates :text, presence: true, length: { maximum: 130 }
  validate :validate_answers

  private

  def validate_answers
    errors.add(:text, :no_answers) unless answers.any?(&:correct?)
  end
end
