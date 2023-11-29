# frozen_string_literal: true

module Admin
  class CampsController < ApplicationController
    def index
      authorize! :index, Camp

      @camps = fetch_season.camps.accessible_by(current_ability)

      render json: @camps
    end

    def new
      @camp = fetch_season.camps.build

      authorize! :create, @camp
    end

    def create
      @camp = fetch_season.camps.build(allowed_params)

      authorize! :create, @camp

      if Interactions::Camps::Creation.new(@camp).execute
        redirect_to camp_location_path(@camp.camp_location), flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @camp = fetch_camp

      authorize! :create, @camp
    end

    def update
      @camp = fetch_camp

      authorize! :update, @camp

      if @camp.update(allowed_params)
        redirect_to camp_location_path(@camp.camp_location), flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @camp = fetch_camp

      authorize! :destroy, @camp

      if @camp.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to camp_location_path(@camp.camp_location)
    end

    private

    def allowed_params
      params.require(:camp).permit(:welcome_video_id, :name, :video)
    end

    def fetch_season
      @fetch_season ||= Season.accessible_by(current_ability)
                              .find(params[:season_id])
    end

    def fetch_camp
      @fetch_camp ||= Camp.find_by!(id: params[:id], season_id: params[:season_id])
    end

    def generate_breadcrumbs
      add_breadcrumb(fetch_season.camp_location.name, camp_location_path(fetch_season.camp_location))
      add_breadcrumb(fetch_season.name)
      add_breadcrumb(fetch_camp.name) if params[:id].present?
    end

    def resource_name
      model_name(Camp)
    end
  end
end
