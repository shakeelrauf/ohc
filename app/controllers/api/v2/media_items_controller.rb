# frozen_string_literal: true

module API
  module V2
    class MediaItemsController < BaseController
      # == [GET] /api/v2/media_items.json
      # Retrieve an index of <MediaItem>s
      # ==== Returns
      # * 200 - success - returns an array of <MediaItem>
      def index
        media_items = MediaItem.accessible_by(current_ability)
                               .active

        render json: API::V2::MediaItemSerializer.new(media_items, serializer_params)
      end
    end
  end
end
