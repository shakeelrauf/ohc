# frozen_string_literal: true

module API
  module V2
    module Admin
      class CampsController < BaseController
        # == [GET] /api/v2/admin/camps/{camp_id}.json
        # Retrieve a camp
        # ==== Returns
        # * 200 - success - returns the camp
        def show
          camp = Camp.find(params[:id])

          render json: API::V2::CampSerializer.new(camp, serializer_params)
        end
      end
    end
  end
end
