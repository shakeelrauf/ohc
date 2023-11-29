# frozen_string_literal: true

module Admin
  class SeasonsController < ApplicationController
    def index
      authorize! :index, Season

      @seasons = fetch_camp_location.seasons.accessible_by(current_ability)

      render json: @seasons
    end

    def new
      @season = fetch_camp_location.seasons.build

      authorize! :create, @season
    end

    def create
      @season = fetch_camp_location.seasons.build(allowed_params)

      authorize! :create, @season

      if @season.save
        redirect_to camp_location_path(@season.camp_location), flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @season = fetch_season

      authorize! :update, @season
    end

    def update
      @season = fetch_season

      authorize! :update, @season

      if @season.update(allowed_params)
        redirect_to camp_location_path(@season.camp_location), flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @season = fetch_season

      authorize! :destroy, @season

      if @season.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to camp_location_path(@season.camp_location)
    end

    private

    def allowed_params
      params.require(:season).permit(:name, :camp_location_id)
    end

    def fetch_camp_location
      @fetch_camp_location ||= CampLocation.accessible_by(current_ability)
                                           .find(params[:camp_location_id])
    end

    def fetch_season
      @fetch_season ||= Season.includes(:camp_location)
                              .find_by!(id: params[:id], camp_location_id: params[:camp_location_id])
    end

    def generate_breadcrumbs
      add_breadcrumb(fetch_camp_location.name, camp_location_path(fetch_camp_location))
      add_breadcrumb(fetch_season.name) if params[:id].present?
    end

    def resource_name
      model_name(Season)
    end
  end
end
