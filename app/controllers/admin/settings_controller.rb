# frozen_string_literal: true

module Admin
  class SettingsController < ApplicationController
    def index
      authorize! :index, Setting

      @settings = Setting.accessible_by(current_ability, :index)
                         .order(:name)
                         .page(params[:page])
    end

    def edit
      @setting = fetch_setting

      authorize! :update, @setting
    end

    def update
      @setting = fetch_setting

      authorize! :update, @setting

      if @setting.update(allowed_params)
        redirect_to settings_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    private

    def fetch_setting
      @fetch_setting ||= Setting.find(params[:id])
    end

    def allowed_params
      params.require(:setting).permit(:name, :value, :visible)
    end

    def resource_name
      model_name(Setting)
    end
  end
end
