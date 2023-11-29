# frozen_string_literal: true

class Setting < ApplicationRecord
  scope :visible, -> { where(visible: true) }
  scope :hidden, -> { where(visible: false) }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :value, presence: true

  def self.alert_email_addresses
    (find_by(name: 'Alert Email')&.value || Rails.application.secrets.email[:alert_address])&.split(',')&.map(&:strip)
  end

  def self.contact_email_addresses
    (find_by(name: 'Contact Email')&.value || Rails.application.secrets.email[:contact_address])&.split(',')&.map(&:strip) 
  end
end
