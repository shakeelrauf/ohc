# frozen_string_literal: true

module API
  module V2
    module Admin
      class SeasonsController < BaseController
        # == [GET] /api/v2/seasons.json
        # Retrieve an index of seasons for the user's ability
        # ==== Returns
        # * 200 - success - returns the seasons
        def index
          seasons = Season.accessible_by(current_ability).order(created_at: :desc)

          render json: API::V2::SeasonSerializer.new(seasons, serializer_params)
        end
      end
    end
  end
end
