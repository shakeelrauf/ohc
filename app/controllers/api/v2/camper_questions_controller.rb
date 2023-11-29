# frozen_string_literal: true

module API
  module V2
    class CamperQuestionsController < BaseController
      before_action :ensure_child

      # == [GET] /api/v2/camper_questions.json
      # Retrieve an index of questions for a user
      # ==== Returns
      # * 200 - success - returns the questions
      def index
        camper_questions = current_user.camper_questions

        camper_questions.answered.update_all(read: true)

        render json: API::V2::CamperQuestionSerializer.new(camper_questions, serializer_params)
      end

      # == [POST] /api/v2/camper_questions.json
      # Create a question
      # ==== Required
      # * text - the question to be asked
      def create
        camper_question = current_user.camper_questions.build(allowed_params_with_tenant)
        camper_question.attendance = current_user.attendances.last

        if Interactions::CamperQuestions::Creation.new(camper_question).execute
          render json: API::V2::CamperQuestionSerializer.new(camper_question, serializer_params), status: :created
        else
          render_object_error object: camper_question, serializer: API::V2::CamperQuestionSerializer, status: :unprocessable_entity
        end
      end

      # == [GET] /api/v2/camper_questions/unread.json
      # Check if the current user has any answered unread camper questions
      # ==== Returns
      # * 200 - User has some answered unread questions
      # * 204 - User has no answered unread questions
      def unread
        if current_user.camper_questions.answered.where(read: false).exists?
          head :ok
        else
          head :no_content
        end
      end

      private

      def allowed_params
        params.from_jsonapi.require(:camper_question).permit(:text)
      end

      def ensure_child
        head :unauthorized unless current_user.child?
      end
    end
  end
end
