# frozen_string_literal: true

class Import
  module Concerns
    module RowProcessorMethods
      def initialize(row_data, scope, tenant)
        @row_data = self.class::ROW_DATA_CLASS.new(row_data)
        @scope = scope
        @tenant = tenant
        @errors = Set.new
      end

      # Getter for Errors to convert the Set to an Array.
      def errors
        @errors.to_a
      end

      def execute
        user = find_or_create_user
        cabin = find_cabin

        find_or_create_attendance(user, cabin) if user.present? && cabin.present?

        self
      end

      def find_or_create_attendance(user, cabin)
        attendance = FindOrCreateAttendance.new(user, cabin).execute

        @errors += attendance.errors.full_messages if attendance.errors.any?
      end

      private

      def find_or_create_user
        user = FindOrCreateUser.new(@row_data, @tenant).execute

        return user unless user.errors.any?

        @errors += user.errors.full_messages

        nil
      end

      def find_cabin
        raise 'The `find_cabin` method must be overwritten in the class that includes this concern.'
      end
    end
  end
end
