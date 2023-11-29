# frozen_string_literal: true

module Interactions
  module Authentications
    class SendPasswordResetEmail
      def initialize(email, view_context)
        @email = email
        @view_context = view_context
      end

      def execute
        return false if @email.blank? || users.none?

        PasswordMailer.reset_multiple(sender, @email, registered, unregistered).deliver_later
      end

      private

      def users
        @users ||= User.includes(:attendances, :authentication)
                       .where(email: @email)
      end

      def authentications
        @authentications ||= users.map(&:authentication)
                                  .compact
                                  .uniq
      end

      def registered
        authentications.each(&:ensure_reset_token!)

        authentications.map do |authentication|
          link_options = default_password_link_options.merge(reset_token: authentication.password_reset_token.token)

          {
            label: authentication.username,
            link: @view_context.edit_password_url(authentication, link_options)
          }
        end
      end

      def unregistered
        users.select { |user| user.authentication_id.blank? }.map do |user|
          user.attendances.collect do |attendance|
            {
              label: "#{attendance.user&.full_name} - #{attendance.camp_location.name} - #{attendance.camp.name}",
              code: attendance.code
            }
          end
        end.flatten
      end

      def sender
        Rails.application.secrets.email[:from_address]
      end

      def default_password_link_options
        if Rails.application.secrets.password_reset_host.present?
          { host: Rails.application.secrets.password_reset_host }
        else
          {}
        end
      end
    end
  end
end
