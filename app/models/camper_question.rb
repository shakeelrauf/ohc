# frozen_string_literal: true

class CamperQuestion < ApplicationRecord
  include TenantResource

  belongs_to :admin, class_name: 'User::Admin', optional: true
  belongs_to :child, class_name: 'User::Child'
  belongs_to :attendance

  scope :unanswered, -> { where(reply: nil) }
  scope :answered, -> { where.not(reply: nil) }

  validates :text, presence: true
  validates :reply, presence: true, on: :update
end
