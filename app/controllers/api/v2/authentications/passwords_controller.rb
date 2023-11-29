# frozen_string_literal: true

class API::V2::Authentications::PasswordsController < API::V2::BaseController
  skip_before_action :authenticate_user

  # == [POST] /api/v2/authentications/passwords.json
  # Send password reset email for authentications if any authentications exist with that email address
  # ==== Required
  # * email - email address to match authentications against
  # ==== Returns
  # * 200 - ok
  def create
    Interactions::Authentications::SendPasswordResetEmail.new(allowed_params[:email], self).execute

    head :ok
  end

  # == [GET] /api/v2/authentications/passwords/:reset_token.json
  # Verify a password reset token for a authentication
  # ==== Required
  # * reset_token (present in url) - the authentications password reset token
  # ==== Returns
  # * 200 - success - valid password reset token
  # * 404 - failure - invalid password reset token
  def show
    fetch_authentication_from_reset_token

    head :ok
  end

  # == [PATCH] /api/v2/authentications/passwords/:reset_token.json
  # Update a authentication's password via their reset token
  # ==== Required
  # * reset_token (present in URL) - the authentications password reset token
  # * password - the authentications new password
  # ==== Returns
  # * 200 - success - returns the updated authentication
  # * 422 - failure - returns an array of authentication validation errors
  # * 404 - failure - invalid password reset token
  def update
    authentication = fetch_authentication_from_reset_token

    head :unprocessable_entity unless authentication

    if authentication.update(password: allowed_params[:password], changing_password: true)
      authentication.password_reset_token.destroy

      render json: API::V2::AuthenticationSerializer.new(authentication)
    else
      render_object_error object: authentication, serializer: API::V2::AuthenticationSerializer, status: :unprocessable_entity
    end
  end

  private

  def fetch_authentication_from_reset_token
    raise ActiveRecord::RecordNotFound if params[:reset_token].blank?

    Authentication::Token::PasswordReset.valid.find_by!(token: params[:reset_token]).authentication
  end

  def allowed_params
    params.from_jsonapi.require(:authentication).permit(:email, :password)
  end
end
