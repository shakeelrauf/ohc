# frozen_string_literal: true

module Attendances
  extend ActiveSupport::Concern

  included do
    has_many :attendances, dependent: :restrict_with_error
  end

  def attendance_codes
    attendances.pluck(:code)
  end
end
