# frozen_string_literal: true

class Abilities::Admin::SuperAdmin
  include CanCan::Ability

  def initialize(user, tenant)
    can %i[new], Attendance
    can %i[create index read update destroy], Attendance, user: { tenant_id: tenant.id }
    can %i[create index read update destroy], Cabin, camp_location: { tenant_id: tenant.id }
    can %i[create index read update destroy], Camp, camp_location: { tenant_id: tenant.id }
    can %i[create index read update destroy], CampLocation, tenant_id: tenant.id
    can %i[create index read update destroy], CamperQuestion, tenant_id: tenant.id
    can %i[create index read update destroy], ContactEmailMessage, tenant_id: tenant.id
    can %i[create index read update destroy start stop open notify], Event::CabinEvent, tenant_id: tenant.id
    can %i[create index read update destroy start stop open notify], Event::CampEvent, tenant_id: tenant.id
    can %i[create index read update destroy start stop open notify], Event::NationalEvent, tenant_id: tenant.id
    can %i[create index read update destroy], Import, tenant_id: tenant.id
    can %i[create index read update destroy], MediaItem::CampMediaItem, tenant_id: tenant.id
    can %i[create index read update destroy], MediaItem::NationalMediaItem, tenant_id: tenant.id
    can %i[create index read update destroy], Score, user: { tenant_id: tenant.id }
    can %i[create index read update destroy], Season, camp_location: { tenant_id: tenant.id }
    can %i[create index read update destroy], Theme, tenant_id: tenant.id
    can %i[read review], User, tenant_id: tenant.id
    can %i[index review], User::Admin, tenant_id: tenant.id
    can %i[create read update destroy], User::Admin, tenant_id: tenant.id, role: User::Admin.roles.values.reject { |v| v == User::Admin.roles[:tenant_admin] }
    can %i[create index read update destroy merge], User::Child, tenant_id: tenant.id
    can %i[create index read update destroy], WelcomeVideo, tenant_id: tenant.id

    # Tenancy
    can %i[edit update], Tenant, id: tenant.id
    can %i[read], ColorTheme

    # Imports
    can %i[index create show], :camps_imports
  end
end
