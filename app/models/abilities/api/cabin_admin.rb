# frozen_string_literal: true

class Abilities::API::CabinAdmin
  include CanCan::Ability

  def initialize(user)
    # Cabins
    can %i[index], Cabin, id: user.cabin_ids

    # Events
    can %i[index read], Event, tenant_id: user.tenant_id, type: 'Event::NationalEvent'
    can %i[index read], Event, tenant_id: user.tenant_id, type: 'Event::CampEvent', targets: { target_type: 'Camp', target_id: user.camp_ids }
    can %i[index read create update destroy start stop open notify], Event, tenant_id: user.tenant_id, type: 'Event::CabinEvent', targets: { target_type: 'Cabin', target_id: user.cabin_ids }

    # Media Items
    can %i[index], MediaItem, tenant_id: user.tenant_id, camp_id: user.camp_ids.push(nil)

    # Seasons
    can %i[index], Season, camp_location: { tenant_id: user.tenant_id, id: user.camp_location_ids }

    # Streams
    can %i[read], Stream, id: user.tenant.streams.ids, event: { targets: { target_type: 'Cabin', target_id: user.cabin_ids } }

    # Themes (Quizzes)
    can %i[index], Theme, tenant_id: user.tenant_id, camp_location_id: [nil, user.camp_location_ids]

    # Reachable Users (Users that the user can converse with)
    # Any Child Camper in any of their assigned cabins
    can %i[message], User, tenant_id: user.tenant_id,
                           id: user.cabins.map(&:child_ids).flatten.uniq
  end
end
