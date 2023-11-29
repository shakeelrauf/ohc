# frozen_string_literal: true

module AdminHelper
  def title_bar(title = '', &block)
    content_for(:title) { title }
    content_for(:buttons, &block)
  end

  def new_button(text, link, btn_style: 'btn-primary')
    link_to "#{icon('plus-circle')} #{text}".html_safe, link, class: "btn btn-sm #{btn_style}"
  end

  def edit_button(link, text)
    link_to "#{icon('edit')} #{text}".html_safe, link, class: 'btn btn-sm btn-secondary'
  end

  def delete_button(link, text: 'Delete', remote: true, disabled: false)
    button_text = "#{icon('trash-2')} #{text}".html_safe
    button_options = { class: 'btn btn-sm btn-danger', method: :delete, remote: remote, data: { confirm: 'Are you sure?' } }

    link_to_if !disabled, button_text, link, **button_options do
      content_tag(:span, tabindex: 0, class: 'd-inline-block', data: { toggle: 'tooltip', placement: 'bottom', title: 'Cannot be deleted due to associated content' }) do
        button_tag button_text, class: 'btn btn-sm btn-danger inactive', disabled: true, style: 'pointer-events: none;'
      end
    end
  end

  def merge_button(text, link, btn_style: 'btn-secondary')
    link_to "#{icon('minimize-2')} #{text}".html_safe, link, class: "btn btn-sm #{btn_style}"
  end

  def external_details_button(link, text: 'Details')
    link_to "#{icon('external-link')} #{text}".html_safe, link, class: 'btn btn-sm btn-info', target: :_blank
  end

  def action_button(icon = '', text = '', link = '', class_list: 'btn-secondary', **options)
    link_to "#{icon} #{text}".html_safe, link, **options, class: "btn btn-sm #{class_list}"
  end
end
