# frozen_string_literal: true

module API
  module V2
    module Admin
      class CabinsController < BaseController
        # == [GET] /api/v2/admin/camps/:camp_id/cabins
        # Retrieve an index of cabins of a camp
        # ==== Returns
        # * 200 - success - returns the cabins
        def index
          cabins = Cabin.accessible_by(current_ability)
                        .where(camp_id: params[:camp_id])
                        .where(filter_params)

          render json: API::V2::CabinSerializer.new(cabins, serializer_params)
        end

        private

        def filter_params
          params.permit(filter: [:gender]).fetch(:filter, {})
        end
      end
    end
  end
end
