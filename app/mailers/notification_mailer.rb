# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def camper_question(emails, camper_question, model_name)
    @camper_question = camper_question
    @child = camper_question.child
    @model_name = model_name

    mail(to: emails,
         subject: default_i18n_subject(model: model_name.downcase))
  end
end
