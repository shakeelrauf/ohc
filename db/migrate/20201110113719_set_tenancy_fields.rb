# frozen_string_literal: true

class SetTenancyFields < ActiveRecord::Migration[6.0]
  def up
    tenant = Tenant.find_or_initialize_by(name: 'One Hope Canada')
    tenant.save(validate: false)

    CampLocation.update_all(tenant_id: tenant.id)
    CamperQuestion.update_all(tenant_id: tenant.id)
    ContactEmailMessage.update_all(tenant_id: tenant.id)
    Event.update_all(tenant_id: tenant.id)
    Import.update_all(tenant_id: tenant.id)
    MediaItem.update_all(tenant_id: tenant.id)
    Stream.update_all(tenant_id: tenant.id)
    Theme.update_all(tenant_id: tenant.id)
    User.update_all(tenant_id: tenant.id)
    WelcomeVideo.update_all(tenant_id: tenant.id)
  end

  def down
    CampLocation.update_all(tenant_id: nil)
    CamperQuestion.update_all(tenant_id: nil)
    ContactEmailMessage.update_all(tenant_id: nil)
    Event.update_all(tenant_id: nil)
    Import.update_all(tenant_id: nil)
    MediaItem.update_all(tenant_id: nil)
    Stream.update_all(tenant_id: nil)
    Theme.update_all(tenant_id: nil)
    User.update_all(tenant_id: nil)
    WelcomeVideo.update_all(tenant_id: nil)
  end
end
