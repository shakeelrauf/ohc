# frozen_string_literal: true

module Admin
  module Users
    class AttendancesController < ApplicationController
      def index
        authorize! :index, Attendance

        @user = fetch_user
        @attendances = @user.attendances.accessible_by(current_ability)
      end

      def destroy
        @attendance = fetch_attendance

        authorize! :destroy, @attendance

        if @attendance.destroy
          flash[:notice] = t('flash.actions.destroy.notice', resource_name: model_name(Attendance))
        else
          flash[:error] = t('flash.actions.destroy.error', resource_name: model_name(Attendance))
        end

        redirect_to user_attendances_path(fetch_user)
      end

      private

      def fetch_user
        @fetch_user ||= User.find(params[:user_id])
      end

      def fetch_attendance
        @fetch_attendance ||= fetch_user.attendances.find(params[:id])
      end

      def generate_breadcrumbs
        add_breadcrumb(fetch_user.full_name)
      end
    end
  end
end
