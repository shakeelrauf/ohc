# frozen_string_literal: true

module Video
  extend ActiveSupport::Concern

  included do
    extend Rails.application.routes.url_helpers
    extend ActionDispatch::Routing::UrlFor

    attribute(:video_url) { |object| rails_blob_url(object.video) }
  end
end
