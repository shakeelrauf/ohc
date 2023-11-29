# frozen_string_literal: true

class Authentication
  class Token
    class PasswordReset < Token
      def self.expires_in
        1.day.freeze
      end
    end
  end
end
