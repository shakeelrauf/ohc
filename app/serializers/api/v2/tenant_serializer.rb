# frozen_string_literal: true

class API::V2::TenantSerializer < API::V2::ApplicationSerializer
  extend Rails.application.routes.url_helpers
  extend ActionDispatch::Routing::UrlFor

  set_type :tenant

  attributes :name

  has_many :custom_labels

  attribute :app_layout do |object|
    object.color_theme.app_layout
  end

  attribute :primary_color do |object|
    object.color_theme.primary_color
  end

  attribute :secondary_color do |object|
    object.color_theme.secondary_color
  end

  attribute :logo_url do |object|
    rails_representation_url(object.logo.variant(resize: '300x300')) if object.logo.attached?
  end
end
