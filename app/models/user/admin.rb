# frozen_string_literal: true

class User::Admin < User
  enum role: {
    tenant_admin: 'tenant_admin',
    super_admin: 'super_admin',
    camp_admin: 'camp_admin',
    cabin_admin: 'cabin_admin'
  }

  belongs_to :camp_location, optional: true

  has_many :camper_questions, dependent: :nullify
  has_many :events, dependent: :restrict_with_error

  accepts_nested_attributes_for :authentication

  before_save :ensure_role
  before_save :remove_camp_location_id, if: :super_admin?

  validates :email, uniqueness: { case_sensitive: false }
  validates :camp_location, presence: true, if: :camp_location_required?

  def super_admin?
    tenant_admin? || super
  end

  def can_be_deleted?
    attendances.empty? && events.empty? && media_items.empty?
  end

  private

  def ensure_role
    self.role ||= self.class.roles.values.last
  end

  def remove_camp_location_id
    self.camp_location_id = nil
  end

  def camp_location_required?
    camp_admin? || cabin_admin?
  end
end
