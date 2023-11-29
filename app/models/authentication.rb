# frozen_string_literal: true

class Authentication < ApplicationRecord
  has_many :users, dependent: :nullify

  has_many :tokens, class_name: 'Authentication::Token', dependent: :delete_all
  has_one :api_session_token, class_name: 'Authentication::Token::APISession', dependent: :destroy
  has_one :web_session_token, class_name: 'Authentication::Token::WebSession', dependent: :destroy
  has_one :password_reset_token, class_name: 'Authentication::Token::PasswordReset', dependent: :destroy

  has_secure_password

  attr_accessor :changing_password

  before_validation :check_changing_password

  validates :username, presence: true,
                       length: { in: 6..72, allow_blank: true },
                       uniqueness: { case_sensitive: false, allow_blank: true }
  validates :password, length: { in: 6..72 }, password_format: true, if: :password_required?

  # The currently authenticated / generated token
  attr_accessor :authentication_token

  def ensure_api_token!(ip_address = nil, user_agent = nil)
    # Remove existing token if exists
    api_session_token&.destroy

    token = create_api_session_token!(ip_address: ip_address, user_agent: user_agent)
    self.authentication_token = token.token
  end

  def ensure_web_token!(ip_address = nil, user_agent = nil)
    web_session_token&.destroy

    token = create_web_session_token!(ip_address: ip_address, user_agent: user_agent)

    self.authentication_token = token.token
  end

  def ensure_reset_token!
    password_reset_token&.destroy

    create_password_reset_token!
  end

  private

  def password_required?
    password_digest.nil? || changing_password
  end

  def check_changing_password
    self.changing_password ||= password_digest_changed?
  end
end
