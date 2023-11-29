# frozen_string_literal: true

module Interactions
  module BaseInteractions
    class Creation
      # This is exposed to allow the Test suite to generate realistic uids.
      def self.generate_uid(name)
        "#{name.gsub(/[^0-9a-z]/i, '').downcase}#{rand.to_s[2..5]}"
      end

      def initialize(object)
        object.skip_chat_attribute_validation = true if object.respond_to?(:skip_chat_attribute_validation)

        @object = object
      end

      def execute
        return false unless @object.valid?

        perform_interaction
      end

      private

      def perform_interaction
        capture_uid_error_and_retry { perform_interaction! }
      rescue Cometchat::ResponseError => error
        @object.errors.add(:base, I18n.t('flash.actions.create.error', resource_name: @object.class.name))

        error.full_messages.each do |error_message|
          @object.errors.add(:base, error_message)
        end

        false
      end

      def capture_uid_error_and_retry
        yield
      rescue Cometchat::UidAlreadyExists
        if @retried
          @object.errors.add(:base, I18n.t('flash.actions.create.error', resource_name: @object.class.name))

          return false
        end

        @retried = true
        retry
      end

      def perform_interaction!
        raise '`perform_interaction` should be overridden by the subclass.'
      end
    end
  end
end
