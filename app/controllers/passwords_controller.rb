# frozen_string_literal: true

# Controls the HTTP actions for requesting to reset a user's password and then going through the workflow to do so
# via the web interface.
class PasswordsController < ApplicationController
  skip_authorization_check
  skip_before_action :login_required

  around_action :switch_locale

  layout 'faithspark'

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def new
    @user = User.new
  end

  def create
    Interactions::Authentications::SendPasswordResetEmail.new(params[:user][:email], view_context).execute
  end

  def edit
    @authentication = fetch_authentication
  end

  def update
    @authentication = fetch_authentication

    if @authentication.update(allowed_params.merge(changing_password: true))
      @authentication.password_reset_token.destroy

      redirect_to updated_passwords_path(locale: params[:locale])
    else
      render :edit
    end
  end

  private

  def not_found
    redirect_to unrecognised_passwords_path(locale: params[:locale])
  end

  def fetch_authentication
    raise ActiveRecord::RecordNotFound if params[:reset_token].blank?

    Authentication::Token::PasswordReset.valid.find_by!(token: params[:reset_token])&.authentication
  end

  def allowed_params
    params.require(:authentication).permit(:password, :password_confirmation)
  end

  def switch_locale(&action)
    locale = params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym) ? params[:locale] : I18n.default_locale

    I18n.with_locale(locale, &action)
  end
end
