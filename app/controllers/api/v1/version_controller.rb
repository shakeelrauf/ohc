# frozen_string_literal: true

module API
  module V1
    class VersionController < BaseController
      # == [GET] /api/v1/version.json
      # Retrieve the minimum app version
      # ==== Returns
      # * 200 - success - returns single setting
      def show
        setting = Setting.find_by!(name: Rails.application.secrets.minimum_app_version_setting_name)

        render json: API::V1::SettingSerializer.new(setting)
      end
    end
  end
end
