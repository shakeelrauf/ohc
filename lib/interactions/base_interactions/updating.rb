# frozen_string_literal: true

module Interactions
  module BaseInteractions
    class Updating
      def initialize(object)
        @object = object
      end

      def execute
        return false unless @object.valid?

        perform_interaction
      end

      private

      def perform_interaction
        perform_interaction!
      rescue Cometchat::ResponseError => error
        @object.errors.add(:base, I18n.t('flash.actions.create.error', resource_name: @object.class.name))

        error.full_messages.each do |error_message|
          @object.errors.add(:base, error_message)
        end

        false
      end

      def perform_interaction!
        raise '`perform_interaction` should be overridden by the subclass.'
      end
    end
  end
end
