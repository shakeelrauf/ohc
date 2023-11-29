# frozen_string_literal: true

class ColorTheme < ApplicationRecord
  APP_LAYOUTS = %w[faith_spark my_camp].freeze

  has_many :tenants, dependent: :restrict_with_error

  validates :name, :primary_color, :secondary_color, presence: true
  validates :app_layout, presence: true, inclusion: { in: APP_LAYOUTS }

  def can_be_deleted?
    tenants.none?
  end
end
