# frozen_string_literal: true

module API
  module V2
    module Admin
      class StreamsController < BaseController
        # == [GET] /api/v2/admin/streams.json
        # Note this endpoint is used only for the app to know the quantity of streams available to it.
        # It should not include any sensitive information.
        # ==== Returns
        # * 200 - success - array of <Stream>s
        def index
          streams = Stream.unallocated.limit(current_tenant.streams_available)

          render json: API::V2::StreamSerializer.new(streams, fields: { stream: [:slug] })
        end
      end
    end
  end
end
