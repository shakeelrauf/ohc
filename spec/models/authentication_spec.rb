# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authentication, type: :model do
  it { is_expected.to have_secure_password }

  it { is_expected.to have_many(:users) }

  it { is_expected.to have_many(:tokens).class_name('Authentication::Token').dependent(:delete_all) }
  it { is_expected.to have_one(:api_session_token).class_name('Authentication::Token::APISession') }
  it { is_expected.to have_one(:web_session_token).class_name('Authentication::Token::WebSession') }
  it { is_expected.to have_one(:password_reset_token).class_name('Authentication::Token::PasswordReset') }

  it { is_expected.to validate_presence_of(:username) }

  it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(72) }
  it { is_expected.to validate_length_of(:username).is_at_least(6).is_at_most(72) }
end
