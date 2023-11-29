# frozen_string_literal: true

class Abilities::API
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(User::Child)
      merge Abilities::API::Child.new(user)
    elsif user.is_a?(User::Admin)
      merge Abilities::API::SuperAdmin.new(user) if user.super_admin? || user.tenant_admin?
      merge Abilities::API::CampAdmin.new(user) if user.camp_admin?
      merge Abilities::API::CabinAdmin.new(user) if user.cabin_admin?
    end
  end
end
