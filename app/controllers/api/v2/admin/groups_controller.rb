# frozen_string_literal: true

module API
  module V2
    module Admin
      class GroupsController < BaseController
        before_action :check_user_allowed_to_join_group
        ACCEPTABLE_ERROR_CODES = %w[ERR_SAME_SCOPE].freeze

        # == [POST] /api/v2/admin/groups.json
        # Add the current user to a group
        # ==== Required
        # * id - the group's CometChat GUID
        # ==== Returns
        # * 200 - success - Added to group or already in the group
        # * 401 - failure - Unauthorized
        # * 404 - failure - Group not found
        def create
          user_chat_uid = current_user.chat_uid

          add_member_response = Cometchat::Group.add_members(allowed_params[:guid], admins: [user_chat_uid])
          response_hash = add_member_response.admins[user_chat_uid]

          # We dont mind if they have already joined the group - send an ok anyway
          if response_hash&.dig('success') || (ACCEPTABLE_ERROR_CODES.include? response_hash&.dig('error', 'code'))
            head :ok
          else
            head :not_found
          end

        # Cometchat threw an error
        rescue Cometchat::ResponseError => error
          head error.code
        end

        private

        def allowed_params
          params.from_jsonapi.require(:group).permit(:guid)
        end

        def check_user_allowed_to_join_group
          return if ::Event.exists?(chat_guid: allowed_params[:guid])

          cabin = fetch_cabin

          # Check if the cabin exists and the user is a member of the camp the cabin belongs to
          head :forbidden unless current_user.camps.exists?(id: cabin.camp_id)
        end

        def fetch_cabin
          @fetch_cabin ||= Cabin.find_by!(chat_guid: allowed_params[:guid])
        end
      end
    end
  end
end
