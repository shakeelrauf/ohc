# frozen_string_literal: true

def auth_headers(user = nil)
  user ||= create(:child)

  token = "#{user.tenant_id}.#{user.authentication.ensure_api_token!}"

  { 'HTTP_AUTHORIZATION': ActionController::HttpAuthentication::Token.encode_credentials(token) }
end
