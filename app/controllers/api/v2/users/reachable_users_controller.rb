# frozen_string_literal: true

module API
  module V2
    module Users
      class ReachableUsersController < BaseController
        # == [GET] /api/v2/user/reachable_users.json
        # Retrieve a list of users that the current user can message
        # ==== Returns
        # * 200 - success - returns the array of reachable users
        def index
          users = User.registered
                      .accessible_by(current_ability, :message)
                      .where.not(id: current_user.id)
                      .order(:first_name, :last_name)

          render json: API::V2::UserSerializer.new(users, serializer_params)
        end
      end
    end
  end
end
