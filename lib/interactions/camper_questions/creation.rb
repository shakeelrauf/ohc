# frozen_string_literal: true

module Interactions
  module CamperQuestions
    class Creation
      def initialize(camper_question)
        @camper_question = camper_question
      end

      def execute
        return false unless @camper_question.save

        send_notification

        @camper_question
      end

      def send_notification
        notification_email = @camper_question.attendance&.camp_location&.notification_email&.split(',')&.map(&:strip)

        return if notification_email.blank?

        NotificationMailer.camper_question(notification_email, @camper_question, model_name).deliver_later
      end

      def model_name
        custom_label = @camper_question.child.tenant.custom_labels.find_by(class_name: 'CamperQuestion')

        if custom_label && custom_label.singular.present?
          custom_label.singular
        else
          CamperQuestion.model_name.human
        end
      end
    end
  end
end
