# frozen_string_literal: true

class Authentication
  class Token < ApplicationRecord
    belongs_to :authentication, touch: true

    scope :valid, -> { where('updated_at > ?', Time.now - expires_in) }

    validates :token, presence: true

    before_validation :generate_token

    def self.expires_in
      raise "expires_in must be defined in #{self.class.name}"
    end

    def accessed!
      touch

      self
    end

    private

    def generate_token
      return if token.present?

      loop do
        self.token = SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
        break token unless Authentication::Token.find_by(token: token)
      end
    end
  end
end
