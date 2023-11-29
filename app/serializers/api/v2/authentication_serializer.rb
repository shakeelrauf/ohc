# frozen_string_literal: true

class API::V2::AuthenticationSerializer < API::V2::ApplicationSerializer
  set_type :authentication

  has_many :users, serializer: API::V2::UserSessionSerializer

  attributes :username

  attribute(:authentication_token) do |authentication|
    authentication.api_session_token&.token
  end
end
