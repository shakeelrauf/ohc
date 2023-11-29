# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :scope, polymorphic: true
  belongs_to :user

  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
