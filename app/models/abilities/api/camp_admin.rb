# frozen_string_literal: true

class Abilities::API::CampAdmin
  include CanCan::Ability

  def initialize(user)
    # Cabins
    can %i[index], Cabin, camp_id: user.camp_location.all_camps.ids

    # Events
    can %i[index read], Event, tenant_id: user.tenant_id, type: 'Event::NationalEvent'
    can %i[index read create update destroy start stop open notify], Event, tenant_id: user.tenant_id, type: 'Event::CampEvent', targets: { target_type: 'Camp', target_id: user.camp_location.all_camps.ids }
    can %i[index read create update destroy start stop open notify], Event, tenant_id: user.tenant_id, type: 'Event::CabinEvent', targets: { target_type: 'Cabin', target_id: user.camp_location.all_cabins.ids }

    # Media Items
    can %i[index], MediaItem, tenant_id: user.tenant_id, camp_id: user.camp_location.all_camps.ids.push(nil)

    # Seasons
    can %i[index], Season, camp_location: { tenant_id: user.tenant_id, id: user.camp_location_id }

    # Streams
    can %i[read], Stream, id: user.tenant.streams.ids, event: { targets: { target_type: 'Camp', target_id: user.camp_location.all_camps.ids } }
    can %i[read], Stream, id: user.tenant.streams.ids, event: { targets: { target_type: 'Cabin', target_id: user.camp_location.all_cabins.ids } }

    # Themes (Quizzes)
    can %i[index], Theme, tenant_id: user.tenant_id, camp_location_id: [nil, user.camp_location_id]
  end
end
