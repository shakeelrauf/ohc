# frozen_string_literal: true

module Admin
  module Users
    class MergesController < ApplicationController
      def new
        authorize! :merge, User::Child

        @children = fetch_children
      end

      def create
        authorize! :merge, User::Child

        @source = scope.find_by(id: params[:source_id])
        @destination = scope.find_by(id: params[:destination_id])

        @interaction = Interactions::MergeRelationships.new(@source, @destination)
        @interaction.execute

        flash_notice = t('flash.actions.merged.notice', resource_name: model_name(User::Child, plural: true), confirm_name: model_name(Attendance, plural: true))
        redirect_to user_attendances_path(@destination), flash: { notice: flash_notice }

      rescue Interactions::MergeError, ActiveRecord::RecordNotFound => error
        flash.now[:error] = "#{t('flash.actions.merged.error', resource_name: model_name(User::Child))}, #{error.message}"

        @children = fetch_children

        render :new
      end

      private

      def fetch_children
        scope.order(:first_name, :last_name)
      end

      def scope
        User::Child.accessible_by(current_ability)
      end
    end
  end
end
