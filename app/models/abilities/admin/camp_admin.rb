# frozen_string_literal: true

class Abilities::Admin::CampAdmin
  include CanCan::Ability

  def initialize(user)
    # Attendances
    can %i[create index read update destroy], Attendance, camp: { camp_location: { id: user.camp_location_id } }

    # Cabins
    can %i[create index read update destroy], Cabin, camp: { camp_location: { id: user.camp_location_id } }

    # Camps
    can %i[create index read update destroy], Camp, season: { camp_location_id: user.camp_location_id }

    # Camp Locations
    can %i[index create update read], CampLocation, tenant_id: user.tenant_id, id: user.camp_location_id

    # Camper Questions
    can %i[index edit], CamperQuestion, tenant_id: user.tenant_id, attendance: { camp_id: user.camp_location.all_camps.ids }
    can %i[update destroy], CamperQuestion, tenant_id: user.tenant_id, reply: nil, attendance: { camp_id: user.camp_location.all_camps.ids }

    # Camp Events
    can %i[new], Event::CampEvent, tenant_id: user.tenant_id
    can %i[create index read update destroy start stop open notify], Event::CampEvent, tenant_id: user.tenant_id, targets: { target_type: 'Camp', target_id: user.camp_location.all_camps.ids }

    # NOTE: This will actually get blocked by validation, but without it the user will get unauthorised rather than
    # the validation error
    can %i[create], Event::CampEvent do |event|
      event.new_record? && event.camp_ids.none?
    end

    # Cabin Events
    can %i[new], Event::CabinEvent, tenant_id: user.tenant_id
    can %i[create index read update destroy start stop open notify], Event::CabinEvent, tenant_id: user.tenant_id, targets: { target_type: 'Cabin', target_id: user.camp_location.all_cabins.ids }

    # NOTE: This will actually get blocked by validation, but without it the user will get unauthorised rather than
    # the validation error
    can %i[create], Event::CabinEvent do |event|
      event.new_record? && event.cabin_ids.none?
    end

    # Media Items
    can %i[create index read update destroy], MediaItem::CampMediaItem, tenant_id: user.tenant_id, camp_id: user.camp_location.all_camps.ids

    # Scores
    can %i[read], Score, user_id: user.camp_location.child_ids

    # Seasons
    can %i[create index read update destroy], Season, camp_location_id: user.camp_location_id

    # Quiz Questions
    can %i[create index read update destroy], QuizQuestion, tenant_id: user.tenant_id, theme: { camp_location_id: user.camp_location_id }

    # Themes
    can %i[create index read update destroy], Theme, tenant_id: user.tenant_id, camp_location_id: user.camp_location_id

    # User
    can %i[read], User, tenant_id: user.tenant_id, camp_location_id: user.camp_location_id
    can %i[read review], User, tenant_id: user.tenant_id, id: user.camp_location.user_ids

    # Admins
    can %i[index], User::Admin, tenant_id: user.tenant_id, camp_location_id: user.camp_location_id
    can %i[create read update destroy], User::Admin, tenant_id: user.tenant_id, camp_location_id: user.camp_location_id, role: [User::Admin.roles[:camp_admin], User::Admin.roles[:cabin_admin]]
    can %i[review], User::Admin, tenant_id: user.tenant_id,
                                 camp_location_id: user.camp_location_id,
                                 role: User::Admin.roles[:cabin_admin]
    # Children
    can %i[index read update], User::Child, tenant_id: user.tenant_id, id: user.camp_location.child_ids
    can %i[create merge], User::Child, tenant_id: user.tenant_id, attendances: { camp_id: user.camp_location.camp_ids }

    # Welcome Videos
    can %i[read], WelcomeVideo, tenant_id: user.tenant_id, active: true

    # Imports
    can %i[index create show], :camps_imports
  end
end
