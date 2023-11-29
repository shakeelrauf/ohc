# frozen_string_literal: true

module API
  module V2
    module Admin
      module Events
        class PushNotificationsController < BaseController
          # == [POST] /api/v2/admin/events/{event_id}/push_notifications.json
          # Send a push notification regarding an event
          # ==== Returns
          # * 200 - success
          # * 422 - failure
          def create
            event = fetch_event
            decorated_event = EventDecorator.decorate(event)

            authorize! :notify, event

            push_notification = ::Event::PushNotification.new(event: event,
                                                              body: decorated_event.push_notification_body,
                                                              title: decorated_event.push_notification_title)

            if push_notification.valid?
              push_notification.deliver!

              render json: API::V2::Event::PushNotificationSerializer.new(push_notification, serializer_params)
            else
              render_object_error object: push_notification, serializer: API::V2::Event::PushNotificationSerializer, status: :unprocessable_entity
            end
          end

          private

          def fetch_event
            @fetch_event ||= ::Event.find(params[:event_id])
          end
        end
      end
    end
  end
end
