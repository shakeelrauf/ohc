# frozen_string_literal: true

class Authentication
  class Token
    class WebSession < Token
      def self.expires_in
        30.minutes.freeze
      end
    end
  end
end
