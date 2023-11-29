# frozen_string_literal: true

class API::V2::ContactEmailMessageSerializer < API::V2::ApplicationSerializer
  set_type :contact_email_message

  belongs_to :user

  attributes :text
end
