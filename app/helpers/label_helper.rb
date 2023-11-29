# frozen_string_literal: true

module LabelHelper
  def entry_name_label(model)
    model_name(model).downcase
  end

  def no_items_label(model)
    t('labels.no_items', name: model_name(model, plural: true))
  end

  def new_button_label(model)
    t('labels.new_button', name: model_name(model))
  end

  def create_button_label(model)
    t('labels.create_button', name: model_name(model))
  end

  def edit_button_label(model)
    t('labels.edit_button', name: model_name(model))
  end

  def update_button_label(model)
    t('labels.update_button', name: model_name(model))
  end

  def merge_button_label(model)
    t('labels.merge_button', name: model_name(model, plural: true))
  end
end
