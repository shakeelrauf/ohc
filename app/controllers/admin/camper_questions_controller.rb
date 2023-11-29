# frozen_string_literal: true

module Admin
  class CamperQuestionsController < ApplicationController
    def index
      authorize! :index, CamperQuestion

      @showing_answered = params[:answered] == 'true'
      camper_questions = @showing_answered ? CamperQuestion.answered : CamperQuestion.unanswered

      @camper_questions = camper_questions.accessible_by(current_ability, :index)
                                          .includes(child: [attendances: [camp: [season: :camp_location]]])
                                          .page(params[:page])
    end

    def edit
      @camper_question = fetch_camper_question

      authorize! :update, @camper_question
    end

    def update
      @camper_question = fetch_camper_question

      authorize! :update, @camper_question

      if @camper_question.update(attributes_from_params)
        redirect_to camper_questions_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @camper_question = fetch_camper_question

      authorize! :destroy, @camper_question

      if @camper_question.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to camper_questions_path
    end

    private

    def fetch_camper_question
      @fetch_camper_question ||= CamperQuestion.find(params[:id])
    end

    def allowed_params
      params.require(:camper_question).permit(:reply)
    end

    def attributes_from_params
      allowed_params_with_tenant.tap do |attributes|
        attributes[:admin] = current_user
      end
    end

    def resource_name
      model_name(CamperQuestion)
    end
  end
end
