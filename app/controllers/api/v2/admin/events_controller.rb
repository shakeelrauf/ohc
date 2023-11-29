# frozen_string_literal: true

module API
  module V2
    module Admin
      class EventsController < BaseController
        # == [POST] /api/v2/admin/events.json
        # Create an event
        # ==== Required
        # * active - active state of event (to show in app)
        # * description - event description
        # * ends_at - event end time
        # * name - event name
        # * starts_at - event start time
        # * camp_ids - camps involved in the event
        # * cabin_ids - cabins involved in the event
        # * event_type - event type
        def create
          event = klass.new(allowed_params_with_tenant.except(:event_type))
          authorize! :create, event

          event.admin = current_user
          event_creator = Interactions::Events::Creation.new(event)

          if event_creator.execute
            render json: API::V2::EventSerializer.new(event, serializer_params), status: :created
          else
            render_object_error object: event, serializer: API::V2::EventSerializer, status: :unprocessable_entity
          end
        end

        # == [PATCH] /api/v2/admin/events/:id.json
        # Update an event
        # ==== Optional
        # * active - active state of event (to show in app)
        # * description - event description
        # * ends_at - event end time
        # * name - event name
        # * starts_at - event start time
        # * camp_ids - camps involved in the event
        # * cabin_ids - cabins involved in the event
        # * event_type - event type
        # * action - action to do on the event
        def update
          event = klass.find_by!(id: params[:id])
          authorize! :update, event

          if %w[start open stop].include? allowed_params[:action]
            authorize! allowed_params[:action].to_sym, event

            if event.send("#{allowed_params[:action]}!")
              render json: API::V2::EventSerializer.new(event, serializer_params)
            else
              head :conflict
            end

          elsif event.update(allowed_params.except(:event_type))
            render json: API::V2::EventSerializer.new(event, serializer_params)
          else
            render_object_error object: event, serializer: API::V2::EventSerializer, status: :unprocessable_entity
          end
        end

        # == [DESTROY] /api/v2/admin/events/:id.json
        # destroy an event
        # ==== Required
        # * id - event to destroy (Implied in URL)
        def destroy
          event = ::Event.find_by!(id: params[:id])
          authorize! :destroy, event

          if !event.closed?
            head :conflict
          elsif event.destroy
            head :no_content
          else
            render_object_error object: event, serializer: API::V2::EventSerializer, status: :unprocessable_entity
          end
        end

        private

        def allowed_params
          params.from_jsonapi.require(:event).permit(:active,
                                                     :description,
                                                     :ends_at,
                                                     :name,
                                                     :starts_at,
                                                     :thumbnail,
                                                     :event_type,
                                                     :action,
                                                     camp_ids: [],
                                                     cabin_ids: [])
        end

        def klass
          case allowed_params[:event_type]
          when 'national'
            ::Event::NationalEvent
          when 'camp'
            ::Event::CampEvent
          when 'cabin'
            ::Event::CabinEvent
          else
            ::Event
          end
        end

        def serializer_params
          super.deep_merge(params: { include_url: true })
        end
      end
    end
  end
end
