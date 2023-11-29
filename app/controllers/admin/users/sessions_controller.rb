# frozen_string_literal: true

module Admin
  module Users
    class SessionsController < ApplicationController
      skip_authorization_check
      skip_before_action :login_required
      before_action :redirect_if_logged_in, only: %i[new create]

      layout 'faithspark'

      def new
        @admin = User::Admin.new
      end

      def create
        @admin = User::Admin.find_by(email: allowed_params[:email])

        if @admin&.authentication&.authenticate(allowed_params[:password])
          sign_in(@admin, request.remote_ip, request.user_agent)

          redirect_to root_path
        else
          render_error(t('admins.sessions.fail'))
        end
      end

      def destroy
        sign_out(current_user)

        redirect_to root_path
      end

      private

      def redirect_if_logged_in
        redirect_to root_path if logged_in?
      end

      def render_error(text)
        @admin = User::Admin.new(email: allowed_params[:email])
        @admin.errors.add(:base, text)

        render :new
      end

      def allowed_params
        params.require(:user_admin).permit(:email, :password)
      end
    end
  end
end
