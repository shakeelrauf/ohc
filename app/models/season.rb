# frozen_string_literal: true

class Season < ApplicationRecord
  belongs_to :camp_location

  has_many :camps, dependent: :destroy
  has_many :children, through: :camps
  has_many :users, through: :camps, dependent: :restrict_with_error

  validates :name, presence: true

  def can_be_deleted?
    users.none?
  end
end
