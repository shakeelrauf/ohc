# frozen_string_literal: true

module HasSlug
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, on: :create

    validates :slug, presence: true
  end

  private

  def generate_slug
    return unless name.present?

    self.slug = name.parameterize
  end
end
