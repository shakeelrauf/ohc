# frozen_string_literal: true

module API
  module V2
    class ScoresController < BaseController
      # == [GET] /api/v2/scores.json
      # Retrieve current users highscores for each active theme
      # ==== Returns
      # The high scores
      def index
        # INFO: https://gabi.dev/2016/03/03/group-by-are-you-sure-you-know-it/
        scores = current_user.scores
                             .select('MAX(value) as value,
                                      any_value(scores.id) AS id,
                                      any_value(scores.created_at) AS created_at,
                                      any_value(scores.updated_at) AS updated_at,
                                      any_value(scores.scope_type) AS scope_type,
                                      scores.scope_id,
                                      any_value(scores.user_id) AS user_id')
                             .includes(:scope)
                             .where(scope_type: 'Theme', scope_id: Theme.active.ids)
                             .group(:scope_id)

        render json: API::V2::ScoreSerializer.new(scores, serializer_params)
      end

      # == [POST] /api/v2/scores.json
      # Create a score
      # ==== Returns
      # * 201 - created
      # * 422 - unprocessable entity
      def create
        if params[:data].is_a? Array
          respond_to_score_array
        else
          score = Score.new(allowed_params.merge(user: current_user))

          if score.save
            render json: API::V2::ScoreSerializer.new(score), status: :created
          else
            render_object_error(object: score, serializer: API::V2::ScoreSerializer)
          end
        end
      end

      private

      def respond_to_score_array
        scores = allowed_array_params.map do |score_params|
          Score.new(score_params.merge(user: current_user))
        end

        begin
          Score.transaction { scores.each(&:save!) }
        rescue ActiveRecord::RecordInvalid
          head :unprocessable_entity
        else
          # The score array represents a Theme and its Questions.
          theme_score = scores.find { |score| score.scope_type == 'Theme' }
          # We respond with the highscore Score for the submitted theme
          top_score = current_user.scores
                                  .order(value: :desc)
                                  .find_by(scope_type: 'Theme', scope_id: theme_score.scope_id)

          render json: API::V2::ScoreSerializer.new(top_score), status: :created
        end
      end

      def allowed_params
        convert_to_rails_format(params[:data])
      end

      def allowed_array_params
        @allowed_array_params ||= params['data'].map { |score_object| convert_to_rails_format(score_object) }
      end

      def convert_to_rails_format(score_object)
        # First, convert score_object into the standard JSON API Params format
        score_object_as_param = ActionController::Parameters.new(data: score_object.permit!.to_h)
        attribute_params = score_object_as_param.from_jsonapi.require(:score).permit(:value, :scope_id)

        scope_params = score_object_as_param.require(:data)
                                            .require(:relationships)
                                            .require(:scope)
                                            .require(:data)
                                            .permit(:type)

        attribute_params[:scope_type] = scope_params.dig(:type)&.camelize

        attribute_params
      end
    end
  end
end
