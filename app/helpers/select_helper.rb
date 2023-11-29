# frozen_string_literal: true

module SelectHelper
  def cabins_for_select_for_user(ability)
    Cabin.accessible_by(ability)
         .includes(camp: { season: :camp_location })
         .collect { |cabin| ["#{cabin.camp.season.camp_location.name} | #{cabin.camp.season.name} | #{cabin.camp.name} | #{cabin.name}", cabin.id] }
  end

  def camps_for_select_for_user(ability)
    Camp.accessible_by(ability)
        .includes(season: :camp_location)
        .collect { |camp| ["#{camp.season.camp_location.name} | #{camp.season.name} | #{camp.name}", camp.id] }
  end

  def roles_select_for_user(user, tenant)
    roles = User::Admin.roles.values.collect do |role|
      new_admin = User::Admin.new(tenant: tenant, camp_location: user.camp_location)
      new_admin.role = role

      next unless can?(:create, new_admin)

      [role.humanize, role]
    end

    roles.compact
  end
end
