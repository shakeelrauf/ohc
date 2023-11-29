# frozen_string_literal: true

module API
  module V2
    class SettingsController < BaseController
      skip_before_action :authenticate_user

      # == [GET] /api/v2/settings.json
      # Retrieve an index of settings
      # ==== Returns
      # * 200 - success - returns index of settings
      def index
        settings = Setting.visible

        render json: API::V2::SettingSerializer.new(settings)
      end
    end
  end
end
