# frozen_string_literal: true

module Admin
  class WelcomeVideosController < ApplicationController
    def index
      authorize! :index, WelcomeVideo

      @search = WelcomeVideo.ransack(params[:q])
      @search.sorts = 'name asc' if @search.sorts.empty?

      @welcome_videos = @search.result
                               .accessible_by(current_ability, :index)
                               .page(params[:page])
    end

    def new
      @welcome_video = WelcomeVideo.new(tenant_params)

      authorize! :create, @welcome_video
    end

    def create
      @welcome_video = WelcomeVideo.new(allowed_params_with_tenant)

      authorize! :create, @welcome_video

      if @welcome_video.save
        redirect_to welcome_videos_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @welcome_video = fetch_welcome_video

      authorize! :update, @welcome_video
    end

    def update
      @welcome_video = fetch_welcome_video

      authorize! :update, @welcome_video

      if @welcome_video.update(allowed_params_with_tenant)
        redirect_to welcome_videos_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @welcome_video = fetch_welcome_video

      authorize! :destroy, @welcome_video

      if @welcome_video.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to welcome_videos_path
    end

    private

    def fetch_welcome_video
      @fetch_welcome_video ||= WelcomeVideo.find(params[:id])
    end

    def allowed_params
      params.require(:welcome_video).permit(:active, :name, :video)
    end

    def generate_breadcrumbs
      add_breadcrumb(fetch_welcome_video.name) if params[:id].present?
    end

    def resource_name
      model_name(WelcomeVideo)
    end
  end
end
