# frozen_string_literal: true

module Admin
  class ThemesController < ApplicationController
    def index
      authorize! :index, Theme

      @camp_location = fetch_camp_location

      @search = (@camp_location ? @camp_location.themes : Theme).ransack(params[:q])
      @search.sorts = 'name asc' if @search.sorts.empty?

      @themes = @search.result
                       .accessible_by(current_ability, :index)
                       .includes(:camp_location)
                       .page(params[:page])
    end

    def new
      @theme = Theme.new(tenant_params)
      @theme.camp_location = current_user.camp_location if current_user.camp_admin?

      authorize! :create, @theme
    end

    def create
      @theme = Theme.new(allowed_params_with_tenant)
      @theme.camp_location = current_user.camp_location if current_user.camp_admin?

      authorize! :create, @theme

      if @theme.save
        redirect_to themes_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def show
      @theme = fetch_theme
      @camp_location = fetch_camp_location

      @search = @theme.scores.ransack(params[:q])
      @search.sorts = 'value desc' if @search.sorts.empty?

      @scores = @search.result
                       .includes(:user)

      @scores = @scores.where(user_id: @camp_location.user_ids) if @camp_location

      @paginated_scores = @scores.page(params[:page])

      authorize! :read, @theme
    end

    def edit
      @theme = fetch_theme

      authorize! :update, @theme
    end

    def update
      @theme = fetch_theme

      authorize! :update, @theme

      # NOTE: Due to the way nested forms work we need to make sure the questions are marked as 'dirty' to ensure
      # the validation checks on answers are performed.
      @theme.assign_attributes(allowed_params)
      @theme.quiz_questions.each(&:text_will_change!)

      if @theme.save
        redirect_to themes_path, flash: { notice: t('flash.actions.update.notice', resource_name: resource_name) }
      else
        render :edit
      end
    end

    def destroy
      @theme = fetch_theme

      authorize! :destroy, @theme

      if @theme.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to themes_path
    end

    private

    def fetch_theme
      @fetch_theme ||= Theme.find(params[:id])
    end

    def fetch_camp_location
      camp_location_id = params.dig(:q, :camp_location_id)

      return nil if camp_location_id.blank?

      @fetch_camp_location ||= CampLocation.accessible_by(current_ability).find(camp_location_id)
    end

    def allowed_params
      answers_attributes = [:id, :text, :correct, :_destroy]
      question_attributes = [:id, :text, :_destroy, answers_attributes: answers_attributes]

      params.require(:theme).permit(:name,
                                    :active,
                                    :camp_location_id,
                                    quiz_questions_attributes: question_attributes)
    end

    def resource_name
      model_name(Theme)
    end
  end
end
