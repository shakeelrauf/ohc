# frozen_string_literal: true

module Admin
  class ColorThemesController < ApplicationController
    def index
      authorize! :index, ColorTheme

      @color_themes = ColorTheme.accessible_by(current_ability, :index)
                                .order(name: :asc)
                                .page(params[:page])
    end

    def new
      @color_theme = ColorTheme.new

      authorize! :create, @color_theme
    end

    def create
      @color_theme = ColorTheme.new(allowed_params)

      authorize! :create, @color_theme

      if @color_theme.save
        redirect_to color_themes_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @color_theme = fetch_color_theme

      authorize! :update, @color_theme
    end

    def update
      @color_theme = fetch_color_theme

      authorize! :update, @color_theme

      if @color_theme.update(allowed_params)
        redirect_to color_themes_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @color_theme = fetch_color_theme

      authorize! :destroy, @color_theme

      if @color_theme.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to color_themes_path
    end

    private

    def fetch_color_theme
      @color_theme = ColorTheme.find(params[:id])
    end

    def allowed_params
      params.require(:color_theme).permit(:app_layout,
                                          :name,
                                          :primary_color,
                                          :secondary_color)
    end

    def resource_name
      model_name(ColorTheme)
    end
  end
end
