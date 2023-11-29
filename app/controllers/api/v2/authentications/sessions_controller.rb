# frozen_string_literal: true

class API::V2::Authentications::SessionsController < API::V2::BaseController
  skip_before_action :authenticate_user, only: %i[create]

  # == [POST] /api/v2/authentications/sessions.json
  # Login an authentication
  # ==== Required
  # * username - the authentication username
  # * password - the authentication password
  # ==== Returns
  # * 201 - success - returns the authentication
  # * 422 - failure - returns the invalid login validation error
  def create
    authentication = Authentication.find_by(username: allowed_params[:username]) if allowed_params[:username].present?

    if authentication&.authenticate(allowed_params[:password])
      authentication.ensure_api_token!(request.remote_ip, request.user_agent)

      render json: API::V2::AuthenticationSerializer.new(authentication, serializer_params), status: :created
    else
      render_failed_user
    end
  rescue ActiveRecord::RecordInvalid => error
    Airbrake.notify(error.message, details: error.backtrace)
    render_failed_user
  end

  # == [GET] /api/v2/authentications/sessions.json
  # Validate the current authentication session
  # ==== Required
  # * authentication_token - the users authentication_token
  # ==== Returns
  # * 200 - success - returns the authentication
  # * 404 - failure - user not found
  def show
    render json: API::V2::AuthenticationSerializer.new(fetch_authentication, serializer_params)
  end

  # == [DELETE] /api/v2/authentications/sessions.json
  # Destroy the current authentication session
  # ==== Required
  # * authentication_token - the users authentication_token
  # ==== Returns
  # * 200 - success - user session destroyed
  # * 404 - failure - user not found
  def destroy
    fetch_authentication&.api_session_token.destroy

    head :no_content
  end

  private

  def fetch_authentication
    @fetch_authentication ||= current_user.authentication
  end

  def allowed_params
    params.from_jsonapi.require(:authentication).permit(:email,
                                                        :username,
                                                        :password)
  end

  def render_failed_user
    failed_auth = Authentication.new
    failed_auth.errors.add(:base, :invalid_login)

    render_object_error object: failed_auth, serializer: API::V2::AuthenticationSerializer, status: :unprocessable_entity
  end
end
