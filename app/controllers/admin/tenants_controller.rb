# frozen_string_literal: true

module Admin
  class TenantsController < ApplicationController
    def index
      authorize! :index, Tenant

      @tenants = Tenant.accessible_by(current_ability, :index)
                       .order(name: :asc)
                       .page(params[:page])
    end

    def new
      @tenant = Tenant.new
      @tenant.initialize_custom_labels
      @tenant.color_theme = ColorTheme.accessible_by(current_ability).first

      authorize! :create, @tenant
    end

    def create
      @tenant = Tenant.new(allowed_params)

      authorize! :create, @tenant

      if @tenant.save
        redirect_to redirect_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @tenant = fetch_tenant
      @tenant.initialize_custom_labels

      authorize! :update, @tenant
    end

    def update
      @tenant = fetch_tenant

      authorize! :update, @tenant

      if @tenant.update(allowed_params)
        redirect_to redirect_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @tenant = fetch_tenant

      authorize! :destroy, @tenant

      if @tenant.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to tenants_path
    end

    def switch
      @tenant = fetch_tenant

      authorize! :switch, @tenant

      session[:tenant_id] = @tenant.id

      redirect_to admin_root_path
    end

    def reset
      authorize! :reset, Tenant

      session.delete(:tenant_id)

      redirect_to tenants_path
    end

    private

    def fetch_tenant
      @tenant = Tenant.find(params[:id])
    end

    def redirect_path
      current_user.tenant_admin? && !current_tenant ? tenants_path : admin_root_path
    end

    def allowed_params
      permitted_attributes = %i[color_theme_id name logo]

      if current_user.tenant_admin?
        permitted_attributes += %i[max_users max_streams max_stream_hours]
      end

      permitted_attributes += [custom_labels_attributes: [:id, :class_name, :locale, :singular, :plural]]

      params.require(:tenant).permit(permitted_attributes)
    end

    def resource_name
      model_name(Tenant)
    end
  end
end
