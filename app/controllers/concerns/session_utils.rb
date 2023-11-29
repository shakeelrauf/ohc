# frozen_string_literal: true

module SessionUtils
  extend ActiveSupport::Concern
  include TenantUtils

  included do
    helper_method :current_user
    helper_method :current_tenant
    helper_method :logged_in?
  end

  def logged_in?
    current_user
  end

  def current_user
    # If they have no session or session key or cookie then return nil
    return nil unless session[:admin_id] && session[:authentication_token]

    # Find a user aslong as current user doesnt exist
    @current_user ||= begin
      token = Authentication::Token::WebSession.valid
                                               .find_by(token: session[:authentication_token])

      return nil unless token

      user = token.authentication
                  .users
                  .find_by(id: session[:admin_id])

      return nil unless user

      token.accessed!

      user.accessed!
    end

    # Return the user
    @current_user
  end

  def sign_in(admin, ip_address, user_agent)
    session[:admin_id] = admin.id
    session[:authentication_token] = admin.authentication.ensure_web_token!(ip_address, user_agent)

    @current_user = admin
  end

  def sign_out(admin)
    admin&.authentication&.web_session_token&.destroy

    reset_session
  end
end
