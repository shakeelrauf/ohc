# frozen_string_literal: true

class ContactEmailMessage < ApplicationRecord
  include TenantResource

  belongs_to :user
  before_validation :generate_identifier!, if: -> { identifier.nil? }

  validates :identifier, uniqueness: { case_sensitive: false }
  validates :text, presence: true

  class << self
    # Whether an identifier is already taken by an existing record
    # @return [Boolean] True if the identifier is already taken
    def identifier_taken?(id_candidate)
      exists?(identifier: id_candidate)
    end

    # Returns a new unique identifier that has not already been taken by an existing record
    # @return [String] New unique identifier
    def generate_identifier
      loop do
        id_candidate = SecureRandom.alphanumeric(15)

        return id_candidate unless identifier_taken?(id_candidate)
      end
    end
  end

  private

  # Assigns a unique identifier to the contact email
  # @return [void]
  def generate_identifier!
    self.identifier = self.class.generate_identifier
  end
end
