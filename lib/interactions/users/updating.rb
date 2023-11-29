# frozen_string_literal: true

module Interactions
  module Users
    class Updating < BaseInteractions::Updating
      def perform_interaction!
        if @object.save
          @object.attendances.each do |attendance|
            Interactions::Attendances::Updating.new(attendance).execute
          end
        end

        @object
      end
    end
  end
end
