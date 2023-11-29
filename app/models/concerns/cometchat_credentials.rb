# frozen_string_literal: true

module CometchatCredentials
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_chat_attribute_validation, :validate_chat_auth_token

    validates :chat_uid, presence: true, unless: :skip_chat_attribute_validation
    validates :chat_auth_token, presence: true, if: :validate_chat_auth_token
  end

  def create_cometchat_auth_token
    Cometchat::AuthToken.create(chat_uid).auth_token
  rescue Cometchat::ResponseError => error
    Airbrake.notify(I18n.t('users.chat_auth_token.failure'), messages: error.full_messages.join(', '), body: error.body)

    nil
  end
end
