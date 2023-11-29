# frozen_string_literal: true

module Admin
  class AdminsController < ApplicationController
    def index
      authorize! :index, User::Admin

      @search = User::Admin.ransack(search_params)
      @search.sorts = 'last_name asc' if @search.sorts.empty?

      @admins = @search.result
                       .accessible_by(current_ability, :index)
                       .includes(:authentication, :camp_location)
                       .page(params[:page])

      @new_admin = initialize_admin
    end

    def new
      @admin = initialize_admin
      @admin.build_authentication

      authorize! :create, @admin
    end

    def create
      @admin = User::Admin.new(attributes_from_params)

      authorize! :create, @admin

      if Interactions::Users::Creation.new(@admin).execute
        redirect_to admins_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @admin = fetch_admin

      authorize! :update, @admin
    end

    def update
      @admin = fetch_admin
      @admin.authentication.changing_password = true if allowed_params.dig(:authentication_attributes, :password).present?
      @admin.assign_attributes(attributes_from_params)

      authorize! :update, @admin

      if Interactions::Users::Updating.new(@admin).execute
        redirect_to update_redirect_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @admin = fetch_admin

      authorize! :destroy, @admin

      if @admin.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to admins_path
    end

    private

    def initialize_admin
      User::Admin.new(tenant_params) do |admin|
        admin.role = User::Admin.roles[:cabin_admin]
        admin.camp_location_id = current_user.camp_location_id unless current_user.super_admin?
      end
    end

    def fetch_admin
      @fetch_admin ||= User::Admin.find(params[:id])
    end

    def allowed_params
      params.require(:user_admin)
            .permit(:camp_location_id,
                    :email,
                    :first_name,
                    :gender,
                    :last_name,
                    :role,
                    :time_zone,
                    authentication_attributes: [:id, :username, :password, :password_confirmation],
                    attendances_attributes: [:id, :camp_id, :cabin_id, :_destroy])
    end

    def search_params
      params.require(:q)
            .permit(:camp_locations_id_eq, :first_name_cont, :last_name_cont, :s)
            .reject { |_, v| v.blank? } if params[:q].present?
    end

    def attributes_from_params
      return allowed_params_with_tenant if current_user.super_admin?

      allowed_params_with_tenant.tap do |attributes|
        attributes[:camp_location_id] = current_user.camp_location_id
      end
    end

    def resource_name
      model_name(User::Admin)
    end

    def update_redirect_path
      can?(:index, User) ? admins_path : root_path
    end
  end
end
