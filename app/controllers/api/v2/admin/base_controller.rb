# frozen_string_literal: true

module API
  module V2
    module Admin
      class BaseController < API::V2::BaseController
        before_action :ensure_admin

        private

        def ensure_admin
          head :unauthorized unless current_user.admin?
        end

        rescue_from CanCan::AccessDenied do
          head :forbidden
        end
      end
    end
  end
end
