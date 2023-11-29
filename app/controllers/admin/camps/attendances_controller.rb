# frozen_string_literal: true

module Admin
  module Camps
    class AttendancesController < ApplicationController
      def index
        @camp = fetch_camp

        authorize! :index, @camp

        respond_to do |format|
          format.csv do
            send_data Camp::CSV.generate(@camp), filename: "#{@camp.name}-campers-#{Date.today}.csv"
          end
        end
      end

      def new
        @camp = fetch_camp

        @attendance = @camp.attendances.build
        @attendance.cabin = @cabin

        authorize! :new, @attendance
      end

      def create
        @camp = fetch_camp

        @attendance = @camp.attendances.build(allowed_params)

        authorize! :create, @attendance

        if Interactions::Attendances::Creation.new(@attendance).execute
          redirect_to camp_cabin_path(@attendance.camp, @attendance.cabin), flash: { notice: t('flash.actions.create.notice', resource_name: 'Attendance') }
        else
          render :new
        end
      end

      def edit
        @attendance = fetch_attendance
        @camp = fetch_camp

        authorize! :update, @attendance
      end

      # @note Only the Cabin can be updated on an Attendance.
      def update
        @attendance = fetch_attendance

        authorize! :update, @attendance

        @attendance.cabin = @attendance.camp.cabins.find_by(id: allowed_params[:cabin_id])

        if Interactions::Attendances::Updating.new(@attendance).execute
          redirect_to camp_cabin_path(@attendance.camp, @attendance.cabin),
                      flash: { notice: t('flash.actions.update.notice', resource_name: 'Attendance') }
        else
          @camp = fetch_camp

          render :edit
        end
      end

      def destroy
        @attendance = fetch_attendance

        authorize! :destroy, @attendance

        if @attendance.destroy
          flash[:notice] = t('flash.actions.destroy.notice', resource_name: 'Attendance')
        else
          flash[:error] = t('flash.actions.destroy.error', resource_name: 'Attendance')
        end

        redirect_to camp_cabin_path(@attendance.camp, @attendance.cabin)
      end

      private

      def fetch_attendance
        @fetch_attendance ||= fetch_camp.attendances.accessible_by(current_ability).find_by(id: params[:id])
      end

      def fetch_camp
        @fetch_camp ||= Camp.accessible_by(current_ability)
                            .find(params[:camp_id])
      end

      def allowed_params
        params.require(:attendance).permit(:user_id, :cabin_id)
      end

      def generate_breadcrumbs
        season = fetch_camp.season

        add_breadcrumb(season.camp_location.name, camp_location_path(season.camp_location))
        add_breadcrumb(season.name)
        add_breadcrumb(fetch_camp.name)
      end
    end
  end
end
