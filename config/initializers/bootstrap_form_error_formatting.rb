# frozen_string_literal: true

module BootstrapForm
  module Components
    module Validation
      extend ActiveSupport::Concern

      private

      def generate_error(name)
        return unless inline_error?(name)

        help_text = get_error_messages(name)
        help_klass = 'invalid-feedback'
        help_tag = :ul

        content_tag(help_tag, help_text, class: help_klass) do
          help_text.each do |error|
            concat content_tag(:li, error)
          end
        end
      end

      def get_error_messages(name)
        object.errors[name]
      end
    end
  end
end
