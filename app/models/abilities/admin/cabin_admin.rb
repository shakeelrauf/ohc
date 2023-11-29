# frozen_string_literal: true

class Abilities::Admin::CabinAdmin
  include CanCan::Ability

  def initialize(user)
    # Cabins
    can %i[index], Cabin, id: user.cabin_ids

    # Events
    can %i[new], Event::CabinEvent, tenant_id: user.tenant_id
    can %i[create index read update destroy start stop open notify], Event::CabinEvent, tenant_id: user.tenant_id, targets: { target_type: 'Cabin', target_id: user.cabin_ids }

    # NOTE: This will actually get blocked by validation, but without it the user will get unauthorised rather than
    # the validation error
    can %i[create], Event::CabinEvent do |event|
      event.new_record? && event.cabin_ids.none?
    end

    # Themes (Quizzes)
    can %i[read], Theme, camp_location_id: user.camp_location_ids

    # Users
    can %i[update], User::Admin, tenant_id: user.tenant_id, id: user.id
  end
end
