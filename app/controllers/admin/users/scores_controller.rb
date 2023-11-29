# frozen_string_literal: true

module Admin
  class Users::ScoresController < ApplicationController
    def index
      authorize! :index, Score

      theme_ids = fetch_user.theme_scores.distinct.pluck(:scope_id)
      themes = Theme.find(theme_ids)

      @scores = themes.each_with_object({}) do |theme, hash|
        hash[theme] = theme.scores
                           .accessible_by(current_ability, :index)
                           .where(user_id: fetch_user.id)
                           .order(value: :desc)
                           .first
      end
    end

    private

    def fetch_user
      @fetch_user ||= User.find(params[:user_id])
    end

    def generate_breadcrumbs
      add_breadcrumb(fetch_user.full_name)
    end
  end
end
