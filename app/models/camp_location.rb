# frozen_string_literal: true

class CampLocation < ApplicationRecord
  include TenantResource

  has_many :admins, dependent: :restrict_with_error, class_name: 'User::Admin'
  has_many :themes, dependent: :destroy

  has_many :seasons, dependent: :destroy
  has_many :camps, through: :seasons
  has_many :children, through: :seasons
  has_many :users, through: :seasons, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :notification_email, email: true

  def all_camps
    Camp.where(season_id: season_ids)
  end

  def all_cabins
    Cabin.where(camp_id: all_camps.ids)
  end

  def can_be_deleted?
    users.empty?
  end
end
