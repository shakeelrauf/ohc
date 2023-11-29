# frozen_string_literal: true

module Admin
  module Events
    class PushNotificationsController < ApplicationController
      def new
        @event = fetch_event
        decorated_event = EventDecorator.decorate(@event)

        authorize! :notify, @event

        @push_notification = Event::PushNotification.new(event: @event,
                                                         body: decorated_event.push_notification_body,
                                                         title: decorated_event.push_notification_title)
      end

      def create
        @event = fetch_event

        authorize! :notify, @event

        @push_notification = Event::PushNotification.new(allowed_params)
        @push_notification.event = @event

        if @push_notification.valid?
          @push_notification.deliver!

          redirect_to events_path(event_type: params[:event_type], past: @event.finished?), flash: { notice: t('flash.event.notified') }
        else
          render :new
        end
      end

      private

      def fetch_event
        @fetch_event ||= Event.find(params[:event_id])
      end

      def allowed_params
        params.require(:event_push_notification).permit(:body, :title)
      end
    end
  end
end
