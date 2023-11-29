# frozen_string_literal: true

module Admin
  class ChildrenController < ApplicationController
    def index
      authorize! :index, User::Child

      @camp_location = fetch_camp_location

      @search = (@camp_location ? @camp_location.children.distinct : User::Child).ransack(params[:q])
      @search.sorts = 'last_name asc' if @search.sorts.empty?

      @children = @search.result
                         .accessible_by(current_ability, :index)
                         .includes(:authentication)
                         .page(params[:page])

      @new_child = initialize_child
    end

    def new
      @child = initialize_child

      authorize! :create, @child
    end

    def create
      @child = User::Child.new(allowed_params_with_tenant)

      authorize! :create, @child

      if Interactions::Users::Creation.new(@child).execute
        redirect_to children_path, flash: { notice: t('flash.actions.create.notice', resource_name: resource_name) }
      else
        render :new
      end
    end

    def edit
      @child = fetch_child

      authorize! :update, @child
    end

    def update
      @child = fetch_child
      @child.assign_attributes(allowed_params_with_tenant)

      authorize! :update, @child

      if Interactions::Users::Updating.new(@child).execute
        redirect_to children_path, flash: { notice: 'Updated' }
      else
        render :edit
      end
    end

    def destroy
      @child = fetch_child

      authorize! :destroy, @child

      if @child.destroy
        flash[:notice] = t('flash.actions.destroy.notice', resource_name: resource_name)
      else
        flash[:error] = t('flash.actions.destroy.error', resource_name: resource_name)
      end

      redirect_to children_path
    end

    private

    def initialize_child
      User::Child.new(tenant_params) do |child|
        child.attendances.build(camp_id: current_user.camp_location&.camp_ids&.first) unless current_user.super_admin?
      end
    end

    def fetch_child
      @fetch_child ||= User::Child.find(params[:id])
    end

    def fetch_camp_location
      camp_location_id = params.dig(:q, :camp_location_id)

      return nil if camp_location_id.blank?

      @fetch_camp_location ||= CampLocation.accessible_by(current_ability).find(camp_location_id)
    end

    def allowed_params
      params.require(:user_child).permit(:first_name,
                                         :last_name,
                                         :date_of_birth,
                                         :email,
                                         :gender,
                                         :password,
                                         attendances_attributes: [:id, :camp_id, :cabin_id, :_destroy])
    end

    def resource_name
      model_name(User::Child)
    end
  end
end
