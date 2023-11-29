# frozen_string_literal: true

class Abilities::Admin
  include CanCan::Ability

  def initialize(user, tenant)
    return if user.is_a?(User::Child)

    # Tenant admins can switch tenants
    tenant = user.tenant_admin? && tenant.present? ? tenant : user.tenant

    merge Abilities::Admin::TenantAdmin.new(user, tenant) if user.tenant_admin?
    merge Abilities::Admin::SuperAdmin.new(user, tenant) if user.super_admin?
    merge Abilities::Admin::CampAdmin.new(user) if user.camp_admin?
    merge Abilities::Admin::CabinAdmin.new(user) if user.cabin_admin?
  end
end
