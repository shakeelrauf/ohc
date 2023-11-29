# frozen_string_literal: true

class API::V2::MediaItemSerializer < API::V2::ApplicationSerializer
  extend Rails.application.routes.url_helpers
  extend ActionDispatch::Routing::UrlFor

  set_type :media_item

  belongs_to :camp, if: proc { |object| object.camp }
  belongs_to :user

  attributes :created_at, :updated_at

  attribute(:attachment_url) do |object|
    rails_blob_url(object.attachment)
  end

  attribute(:attachment_thumbnail_url) do |object|
    if object.attachment.image?
      rails_representation_url(object.attachment.variant(resize: '300x300').processed)
    elsif object.attachment.previewable?
      rails_representation_url(object.attachment.preview(resize_to_limit: [300, 300]).processed)
    end
  end

  attribute(:kind) do |object|
    object.is_a?(MediaItem::NationalMediaItem) ? 'national' : 'camp'
  end

  attribute(:media_type) do |object|
    object.attachment.image? ? 'image' : 'video'
  end
end
