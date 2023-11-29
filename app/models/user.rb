# frozen_string_literal: true

class User < ApplicationRecord
  include Attendances
  include CometchatCredentials
  include TenantResource

  enum gender: { female: 'female', male: 'male' }

  belongs_to :authentication, optional: true
  belongs_to :device_token, optional: true

  has_many :cabins, through: :attendances
  has_many :camps, through: :attendances
  has_many :camp_locations, through: :camps
  has_many :seasons, through: :camps
  has_many :contact_email_messages, dependent: :nullify
  has_many :media_items, dependent: :restrict_with_error
  has_many :scores, dependent: :destroy
  has_many :theme_scores, -> { where(scope_type: 'Theme') }, class_name: 'Score',
                                                             dependent: :nullify,
                                                             inverse_of: :user

  scope :registered, -> { where.not(authentication_id: nil) }
  scope :with_push_notifications, -> { where.not(device_token_id: nil) }

  accepts_nested_attributes_for :attendances, reject_if: :all_blank, allow_destroy: true

  after_destroy :cleanup_authentication

  validates :first_name, :last_name, :gender, presence: true
  validates :email, presence: true, email: true
  validate :validate_max_users, on: :create

  def admin?
    is_a?(User::Admin)
  end

  def child?
    is_a?(User::Child)
  end

  def registered? options={}
    authentication.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def accessed!
    touch(:last_active_at)

    self
  end

  private

  def validate_max_users
    errors.add(:base, :too_many) if tenant && (tenant.users.count + 1 > tenant.max_users)
  end

  def cleanup_authentication
    authentication.destroy if authentication&.users&.none?
  end
end
