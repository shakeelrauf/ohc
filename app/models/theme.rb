# frozen_string_literal: true

class Theme < ApplicationRecord
  include TenantResource

  belongs_to :camp_location, optional: true

  has_many :quiz_questions, dependent: :destroy
  has_many :scores, as: :scope, dependent: :destroy

  scope :active, -> { where(active: true) }

  accepts_nested_attributes_for :quiz_questions, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true, length: { maximum: 24 }
end
