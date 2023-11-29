# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionUtils
  include TenantModelNames

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied, with: :unauthorized

  check_authorization
  before_action :login_required
  before_action :generate_breadcrumbs

  around_action :set_time_zone

  def tenant_params
    current_tenant ? { tenant_id: current_tenant.id } : {}
  end

  helper_method :tenant_params

  private

  def current_ability
    @current_ability ||= Abilities::Admin.new(current_user, current_tenant)
  end

  def login_required
    redirect_to login_path unless logged_in?
  end

  def set_time_zone(&block)
    return yield unless current_user

    Time.use_zone(current_user.time_zone, &block)
  end

  def not_found
    resource_name = action_name == 'index' ? controller_name.capitalize : controller_name.capitalize.singularize

    redirect_with_error(t('flash.errors.not_found', resource_name: resource_name))
  end

  def unauthorized
    redirect_with_error(t('flash.errors.unauthorized'))
  end

  def redirect_with_error(error)
    redirect_to root_url, flash: { error: error }
  end

  def js_flash(level, message)
    flash.now[level] = message

    render 'shared/refresh_flash.js.haml'
  end

  def generate_breadcrumbs
    # NOTE: This method should be overridden in the individual subcontrollers.
  end

  def add_breadcrumb(name, link = nil)
    @breadcrumbs ||= []
    @breadcrumbs << [name, link]
  end
end
