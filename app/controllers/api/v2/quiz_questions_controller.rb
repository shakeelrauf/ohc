# frozen_string_literal: true

module API
  module V2
    class QuizQuestionsController < BaseController
      # == [GET] /api/v2/theme/:theme_id/quiz_questions.json
      # Retrieve an index of quiz questions of a theme
      # ==== Returns
      # * 200 - success - returns the quiz questions
      def index
        render json: API::V2::QuizQuestionSerializer.new(fetch_theme.quiz_questions, serializer_params)
      end

      private

      def fetch_theme
        @fetch_theme ||= Theme.find(params[:theme_id])
      end
    end
  end
end
