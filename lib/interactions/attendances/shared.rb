# frozen_string_literal: true

module Interactions
  module Attendances
    module Shared
      ACCEPTABLE_ERROR_CODES = %w[ERR_SAME_SCOPE].freeze

      def perform_interaction!
        @param_key = @object.user.admin? ? 'admins' : 'participants'
        @user_chat_uid = @object.user.chat_uid

        assign_camp
        assign_cabin if @object.cabin.present?

        @object.save
      end

      private

      def assign_camp
        return if assign_to_guid(@object.camp.chat_guid)

        @object.errors.add(:base, :camp_assignment_fail)
      end

      def assign_cabin
        return if assign_to_guid(@object.cabin.chat_guid)

        @object.errors.add(:base, :cabin_assignment_fail)
      end

      def assign_to_guid(guid)
        assignment = Cometchat::Group.add_members(guid, "#{@param_key}": [@user_chat_uid])

        !errored?(assignment)
      end

      def errored?(group_assignment)
        response_hash = group_assignment.send(@param_key).dig(@user_chat_uid)

        return false if response_hash&.dig('success')
        return false if ACCEPTABLE_ERROR_CODES.include? response_hash&.dig('error', 'code')

        true
      end
    end
  end
end
