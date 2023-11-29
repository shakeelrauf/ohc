# frozen_string_literal: true

module TenantModelNames
  extend ActiveSupport::Concern

  included do
    helper_method :model_name
  end

  def model_name(model, plural: false, locale: I18n.locale)
    custom_label = current_tenant&.custom_labels&.select do |label|
      label.class_name == model.to_s && label.locale == locale.to_s
    end&.first

    value = custom_label&.public_send(plural ? :plural : :singular)

    if value&.present?
      value
    elsif plural
      model.model_name.human(count: 2)
    else
      model.model_name.human
    end
  end
end
