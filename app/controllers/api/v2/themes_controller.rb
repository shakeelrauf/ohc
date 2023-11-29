# frozen_string_literal: true

module API
  module V2
    class ThemesController < BaseController
      # == [GET] /api/v2/themes.json
      # Retrieve an index of themes
      # ==== Returns
      # * 200 - success - returns the themes
      def index
        themes = Theme.accessible_by(current_ability)
                      .active

        render json: API::V2::ThemeSerializer.new(themes, serializer_params)
      end
    end
  end
end
