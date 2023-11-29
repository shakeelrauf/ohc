# frozen_string_literal: true

module Admin
  class CabinsController < ApplicationController
    def index
      authorize! :index, Cabin

      @cabins = fetch_camp.cabins.accessible_by(current_ability)

      render json: @cabins
    end

    def new
      @cabin = fetch_camp.cabins.build

      authorize! :create, @cabin
    end

    def create
      @cabin = fetch_camp.cabins.build(allowed_params)

      authorize! :create, @cabin

      if Interactions::Cabins::Creation.new(@cabin).execute
        redirect_to camp_location_path(@cabin.camp.camp_location), flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def show
      @cabin = fetch_cabin

      authorize! :read, @cabin

      @admin_attendances = fetch_attendances.of_admins.page(params[:admin_page])
      @child_attendances = fetch_attendances.of_children.page(params[:child_page])
    end

    def edit
      @cabin = fetch_cabin

      authorize! :update, @cabin
    end

    def update
      @cabin = fetch_cabin

      authorize! :update, @cabin

      if @cabin.update(allowed_params)
        redirect_to camp_location_path(@cabin.camp.camp_location), flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @cabin = fetch_cabin

      authorize! :destroy, @cabin

      if @cabin.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to camp_location_path(@cabin.camp.camp_location)
    end

    private

    def fetch_attendances
      attendances = @cabin.attendances.includes(:user).order('users.last_name, users.first_name')

      return attendances.search(params[:search_term]) if params[:search_term].present?

      attendances
    end

    def allowed_params
      params.require(:cabin).permit(:welcome_video_id, :name, :gender, :video)
    end

    def fetch_camp
      @fetch_camp || Camp.accessible_by(current_ability)
                         .includes(season: :camp_location)
                         .find(params[:camp_id])
    end

    def fetch_cabin
      @fetch_cabin ||= Cabin.includes(:attendances, camp: { season: :camp_location })
                            .find_by!(id: params[:id], camp_id: params[:camp_id])
    end

    def generate_breadcrumbs
      add_breadcrumb(fetch_camp.season.camp_location.name, camp_location_path(fetch_camp.season.camp_location))
      add_breadcrumb(fetch_camp.season.name)
      add_breadcrumb(fetch_camp.name)

      add_breadcrumb("#{fetch_cabin.name} (#{fetch_cabin.gender})") if params[:id].present?
    end

    def resource_name
      model_name(Cabin)
    end
  end
end
