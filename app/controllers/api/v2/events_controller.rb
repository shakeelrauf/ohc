# frozen_string_literal: true

module API
  module V2
    class EventsController < BaseController
      # == [GET] /api/v2/events.json
      # Retrieve an index of events
      # ==== Returns
      # * 200 - success - returns the events
      def index
        events = scope.accessible_by(current_ability)
                      .order(starts_at: :asc)

        if serializer_params[:include]&.include?('stream')
          head :forbidden
        else
          render json: API::V2::EventSerializer.new(events, serializer_params)
        end
      end

      # == [GET] /api/v2/events/{id}.json
      # Retrieve a single event
      # ==== Required
      # * id - the id of the event to return (Implied in URL)
      # ==== Returns
      # * 200 - success - returns the event
      def show
        event = scope.find(params[:id])

        authorize! :read, event

        merged_serializer_params = serializer_params

        if serializer_params[:include]&.include?('stream')
          authorize! :read, event.stream

          merged_serializer_params.deep_merge!(params: { include_url: true })
        end

        render json: API::V2::EventSerializer.new(event, merged_serializer_params)
      end

      private

      def scope
        ::Event.active.includes(:targets)
      end
    end
  end
end
