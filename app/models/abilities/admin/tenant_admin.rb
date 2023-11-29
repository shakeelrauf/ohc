# frozen_string_literal: true

class Abilities::Admin::TenantAdmin
  include CanCan::Ability

  def initialize(user, tenant)
    can %i[create index read update destroy], ColorTheme
    can %i[create index read update destroy], Setting
    can %i[create index read update destroy stop], Stream
    can %i[create index read update destroy switch reset], Tenant

    merge Abilities::Admin::SuperAdmin.new(user, tenant)

    # Allow them to create tenant admins
    can %i[create index read update destroy], User::Admin, tenant_id: tenant.id

    # Comet chat
    can %i[show], :comet_chat_review
  end
end
