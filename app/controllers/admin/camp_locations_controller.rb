# frozen_string_literal: true

module Admin
  class CampLocationsController < ApplicationController
    def index
      authorize! :index, CampLocation

      @search = CampLocation.ransack(params[:q])
      @search.sorts = 'name asc' if @search.sorts.empty?

      @camp_locations = @search.result
                               .accessible_by(current_ability, :index)
                               .page(params[:page])
    end

    def new
      @camp_location = CampLocation.new(tenant_params)

      authorize! :create, @camp_location
    end

    def create
      @camp_location = CampLocation.new(allowed_params_with_tenant)

      authorize! :create, @camp_location

      if @camp_location.save
        redirect_to camp_location_path(@camp_location), flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def show
      @camp_location = fetch_camp_location

      authorize! :read, @camp_location

      if @camp_location.size == 1
        "hello"
        redirect_to camp_location_path
      else

        @search = @camp_location.seasons
                                .accessible_by(current_ability)
                                .ransack(params[:q])

        @search.sorts = 'name asc' if @search.sorts.empty?

        @seasons = @search.result
                          .page(params[:page])
      end
    end

    def edit
      @camp_location = fetch_camp_location

      authorize! :update, @camp_location
    end

    def update
      @camp_location = fetch_camp_location

      authorize! :update, @camp_location

      if @camp_location.update(allowed_params_with_tenant)
        redirect_to camp_locations_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @camp_location = fetch_camp_location

      authorize! :destroy, @camp_location

      if @camp_location.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to camp_locations_path
    end

    private

    def fetch_camp_location
      @fetch_camp_location ||= CampLocation.find(params[:id])
    end

    def allowed_params
      params.require(:camp_location).permit(:name, :notification_email)
    end

    def generate_breadcrumbs
      add_breadcrumb(fetch_camp_location.name) if params[:id].present?
    end

    def resource_name
      model_name(CampLocation)
    end
  end
end
