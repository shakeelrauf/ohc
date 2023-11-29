# frozen_string_literal: true

module NavHelper
  def nav_link(content, href, icon_name = nil, target: :_self)
    content = model_name(content, plural: true) if content.is_a?(Class)

    render 'shared/nav_link', content: content, href: href, icon_name: icon_name, target: target
  end

  def icon(name)
    content_tag(:i, '', data: { feather: name })
  end

  def sidebar_sublist(title, &block)
    render 'shared/sidebar_sublist', title: title, list: capture(&block)
  end

  def more_button(icon_name = 'more-vertical', &block)
    render 'shared/more_button', icon_name: icon_name, items: capture(&block)
  end
end
