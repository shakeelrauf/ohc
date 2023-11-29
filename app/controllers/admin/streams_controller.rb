# frozen_string_literal: true

module Admin
  class StreamsController < ApplicationController
    def index
      authorize! :index, Stream

      @streams = Stream.accessible_by(current_ability, :index)
                       .order(name: :asc)
                       .page(params[:page])
    end

    def new
      @stream = Stream.new(tenant_params)

      authorize! :create, @stream
    end

    def create
      @stream = Stream.new(allowed_params)

      authorize! :create, @stream

      if @stream.save
        redirect_to streams_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @stream = fetch_stream

      authorize! :update, @stream
    end

    def update
      @stream = fetch_stream

      authorize! :update, @stream

      if @stream.update(allowed_params)
        redirect_to streams_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @stream = fetch_stream

      authorize! :destroy, @stream

      if @stream.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to streams_path
    end

    def stop
      @stream = fetch_stream

      authorize! :stop, @stream

      @stream.event ? @stream.event.stop! : @stream.stop!

      redirect_to streams_path, flash: { notice: t('flash.stream.stopped') }
    end

    private

    def fetch_stream
      @stream = Stream.find(params[:id])
    end

    def allowed_params
      params.require(:stream).permit(:name)
    end

    def resource_name
      model_name(Stream)
    end
  end
end
