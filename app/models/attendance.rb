# frozen_string_literal: true

class Attendance < ApplicationRecord
  belongs_to :cabin
  belongs_to :camp
  belongs_to :user

  has_one :season, through: :camp
  has_one :camp_location, through: :camp
  has_many :camper_questions, dependent: :nullify

  scope :of_admins, -> { includes(user: [:authentication]).where(users: { type: 'User::Admin' }) }
  scope :of_children, -> { includes(user: [:authentication]).where(users: { type: 'User::Child' }) }

  before_validation :ensure_code
  before_validation :ensure_camp_if_cabin

  validate :validate_cabin_is_in_camp
  validates :code, length: { is: 16 }
  validates :cabin_id, presence: true
  validates :camp_id, uniqueness: { scope: :user_id }
  validates :user_id, uniqueness: { scope: :camp_id }
  validate :check_camp_uniqueness

  def self.search(search_term)
    return all unless search_term.present?

    scope = includes(:user)

    search_term.split(' ').each do |term|
      scope = scope.where('users.first_name LIKE :term OR
                           users.last_name LIKE :term OR
                           attendances.code LIKE :term',
                          term: "%#{term}%")
    end

    scope
  end

  def to_csv_row
    [code,
     user.first_name,
     user.last_name,
     user.date_of_birth,
     user.gender,
     user.email,
     cabin&.name]
  end

  private

  def ensure_code
    return if code.present?

    loop do
      self.code = rand(10**15..(10**16 - 1))

      # NOTE: OHC-815 - Prevent 0 being the last character
      break unless (code.last == '0') || self.class.exists?(code: code)
    end
  end

  def ensure_camp_if_cabin
    return if cabin_id.blank? || camp_id.present?

    self.camp_id = cabin.camp_id
  end

  def validate_cabin_is_in_camp
    return if cabin_id.blank? || camp&.cabin_ids&.include?(cabin_id)

    errors.add(:cabin, :invalid)
  end

  # Note: This is required due to attendances being created as part of a nested form for admin/children.
  # At the point validation is run the user_id is blank (because the user is unsaved) meaning the above
  # uniqueness validation doesn't trigger. See: https://github.com/rails/rails/issues/20676
  def check_camp_uniqueness
    return unless user && camp

    camp_ids = user.attendances.map(&:camp_id)

    errors.add(:camp_id, :taken) if camp_ids.select { |i| i == camp_id }.many?
  end
end
