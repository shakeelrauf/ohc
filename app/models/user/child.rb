# frozen_string_literal: true

class User::Child < User
  has_many :camp_locations, -> { distinct }, through: :camps
  has_many :camper_questions, dependent: :destroy

  validates :date_of_birth, presence: true

  def can_be_deleted?
    attendances.empty?
  end
end
