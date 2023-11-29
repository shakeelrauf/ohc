# frozen_string_literal: true

module Admin
  class EventsController < ApplicationController
    def index
      authorize! :index, klass

      @showing_past = params[:past] == 'true'

      @events = klass.accessible_by(current_ability, :index)
      @events = @showing_past ? @events.finished.order(starts_at: :desc) : @events.present.order(active: :desc, starts_at: :asc, name: :asc)

      @events = @events.includes(:admin, :stream, :targets)
                       .page(params[:page])

      @new_event = klass.new(tenant_params)
      @tenant = TenantDecorator.decorate(current_tenant)
    end

    def new
      @event = klass.new(tenant_params)

      authorize! :new, @event

      # INFO: Set some sensible defaults, iOS has issues with blank datetime fields
      @event.starts_at = Time.now.beginning_of_hour + 1.hour
      @event.ends_at = @event.starts_at + 1.hour
    end

    def create
      @event = klass.new(allowed_params_with_tenant)
      @event.admin = current_user

      authorize! :create, @event

      event_creator = Interactions::Events::Creation.new(@event)

      if event_creator.execute
        redirect_to redirect_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @event = fetch_event

      authorize! :update, @event
    end

    def update
      @event = fetch_event

      authorize! :update, @event

      if @event.update(allowed_params_with_tenant)
        redirect_to redirect_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @event = fetch_event

      authorize! :destroy, @event

      if @event.closed? && @event.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to redirect_path
    end

    def start
      @event = fetch_event

      authorize! :start, @event

      if @event.start!
        flash[:notice] = t('flash.event.started')
      else
        flash[:error] = @event.errors.full_messages.to_sentence
      end

      redirect_to redirect_path
    end

    def open
      @event = fetch_event

      authorize! :open, @event

      @event.open!

      redirect_to redirect_path, flash: { notice: t('flash.event.opened') }
    end

    def stop
      @event = fetch_event

      authorize! :stop, @event

      @event.stop!

      redirect_to redirect_path, flash: { notice: t('flash.event.stopped') }
    end

    private

    def allowed_params
      params.require(:event).permit(:active,
                                    :description,
                                    :ends_at,
                                    :name,
                                    :starts_at,
                                    :thumbnail,
                                    camp_ids: [],
                                    cabin_ids: [])
    end

    def fetch_event
      @fetch_event = klass.find(params[:id])
    end

    def redirect_path
      events_path(event_type: params[:event_type], past: @event.finished?)
    end

    def klass
      case params[:event_type]
      when 'national'
        Event::NationalEvent
      when 'camp'
        Event::CampEvent
      when 'cabin'
        Event::CabinEvent
      end
    end

    def resource_name
      model_name(@event.class)
    end
  end
end
