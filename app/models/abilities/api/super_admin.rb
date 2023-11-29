# frozen_string_literal: true

class Abilities::API::SuperAdmin
  include CanCan::Ability

  def initialize(user)
    # Cabins
    can %i[index], Cabin, camp_location: { tenant_id: user.tenant_id }

    # Events
    can %i[index read create update destroy start stop open notify], Event, tenant_id: user.tenant_id

    # Media Items
    can %i[index], MediaItem, tenant_id: user.tenant_id

    # Seasons
    can %i[index], Season, camp_location: { tenant_id: user.tenant_id }

    # Streams
    can %i[index read], Stream, id: user.tenant.streams.ids

    # Themes (Quizzes)
    can %i[index], Theme, tenant_id: user.tenant_id
  end
end
