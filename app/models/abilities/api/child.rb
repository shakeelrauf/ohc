# frozen_string_literal: true

class Abilities::API::Child
  include CanCan::Ability

  def initialize(user)
    # Events
    can %i[index read], Event, tenant_id: user.tenant_id, type: 'Event::NationalEvent'
    can %i[index read], Event, tenant_id: user.tenant_id, type: 'Event::CampEvent', targets: { target_type: 'Camp', target_id: user.camp_ids }
    can %i[index read], Event, tenant_id: user.tenant_id, type: 'Event::CabinEvent', targets: { target_type: 'Cabin', target_id: user.cabin_ids }

    # Media Items
    can %i[index], MediaItem, tenant_id: user.tenant_id, camp_id: user.camp_ids.push(nil)

    # Themes (Quizzes)
    can %i[index], Theme, tenant_id: user.tenant_id, camp_location_id: user.camp_location_ids.push(nil)

    # Reachable Users (Users that the user can converse with)
    can %i[message], User, tenant_id: user.tenant_id,
                           id: user.cabins.map(&:admin_ids).flatten.uniq,
                           role: User::Admin.roles[:cabin_admin]
  end
end
