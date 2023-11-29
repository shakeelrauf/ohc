# frozen_string_literal: true

module Admin
  module Camps
    class ImportsController < ApplicationController
      authorize_resource :camps_imports, class: false

      def new
        @camp = fetch_camp
        @import = @camp.imports.build
      end

      def create
        @camp = fetch_camp
        @import = Import.new(allowed_params_with_tenant.merge(scope: @camp))

        if @import.save
          redirect_to camp_import_path(@camp, @import)
        else
          render :new
        end
      end

      def show
        @import = Import.find(params[:id])

        render 'shared/imports/show'
      end

      def template_csv
        send_file(Rails.root.join('public', 'Faith Spark import template.csv'))
      end

      private

      def allowed_params
        params.require(:import).permit(:csv_file)
      end

      def fetch_camp
        @fetch_camp ||= Camp.accessible_by(current_ability)
                            .includes(:cabins, season: :camp_location)
                            .find(params[:camp_id])
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
