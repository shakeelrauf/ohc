# frozen_string_literal: true

module TenantUtils
  extend ActiveSupport::Concern

  def current_tenant
    return nil unless current_user
    @current_tenant ||= 
                          current_user.tenant
  end

  def allowed_params_with_tenant
    allowed_params.tap do |attributes|
      attributes[:tenant_id] = current_tenant.id
    end
  end
end
