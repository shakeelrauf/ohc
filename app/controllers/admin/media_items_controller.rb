# frozen_string_literal: true

module Admin
  class MediaItemsController < ApplicationController
    def index
      authorize! :index, klass

      @camp = fetch_camp

      @search = scope.ransack(params[:q])
      @search.sorts = ['active desc', 'created_at asc'] if @search.sorts.empty?

      @media_items = @search.result
                            .accessible_by(current_ability, :index)
                            .includes(:user)
                            .with_attached_attachment
                            .page(params[:page])

      @new_media_item = klass.new
    end

    def new
      @media_item = scope.new(tenant_params)

      authorize! :create, @media_item
    end

    def create
      @media_item = scope.new(attributes_from_params)

      authorize! :create, @media_item

      respond_to do |format|
        if @media_item.save
          format.js { head :created }
          format.html do
            redirect_to redirect_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
          end
        else
          format.js { render status: 400 }
          format.html { render :new }
        end
      end
    end

    def edit
      @media_item = fetch_media_item

      authorize! :update, @media_item
    end

    def update
      @media_item = fetch_media_item

      authorize! :update, @media_item

      if @media_item.update(attributes_from_params)
        redirect_to redirect_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @media_item = fetch_media_item

      authorize! :destroy, @media_item

      if @media_item.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to redirect_path
    end

    private

    def allowed_params
      params.require(:media_item).permit(:active, :attachment)
    end

    def fetch_camp
      return nil if params[:camp_id].blank?

      @fetch_camp || Camp.accessible_by(current_ability)
                         .find(params[:camp_id])
    end

    def fetch_media_item
      @fetch_media_item ||= klass.find(params[:id])
    end

    def attributes_from_params
      allowed_params_with_tenant.tap do |attributes|
        attributes[:user_id] = current_user.id
      end
    end

    def redirect_path
      fetch_camp ? camp_media_items_path(fetch_camp) : media_items_path
    end

    def scope
      params[:camp_id].present? ? fetch_camp.media_items : klass
    end

    def klass
      params[:camp_id].present? ? MediaItem::CampMediaItem : MediaItem::NationalMediaItem
    end

    def generate_breadcrumbs
      if fetch_camp
        add_breadcrumb(fetch_camp.season.camp_location.name, camp_location_path(fetch_camp.season.camp_location))
        add_breadcrumb(fetch_camp.season.name)
        add_breadcrumb(fetch_camp.name)
        add_breadcrumb('Gallery', camp_media_items_path(fetch_camp))
      else
        add_breadcrumb('Gallery', media_items_path)
      end

      add_breadcrumb(fetch_media_item.attachment.filename) if params[:id].present?
    end

    def resource_name
      model_name(MediaItem)
    end
  end
end
