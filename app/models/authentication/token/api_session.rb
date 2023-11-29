# frozen_string_literal: true

class Authentication
  class Token
    class APISession < Token
      def self.expires_in
        1.month.freeze
      end
    end
  end
end
