# frozen_string_literal: true

class API::V2::EventSerializer < API::V2::ApplicationSerializer
  extend Rails.application.routes.url_helpers
  extend ActionDispatch::Routing::UrlFor

  set_type :event

  has_many :targets, record_type: :target, serializer: API::V2::Event::TargetSerializer

  has_one :stream

  attributes :chat_guid, :description, :ends_at, :kind, :name, :starts_at, :status, :url

  attribute(:attachment_url) do |object|
    rails_representation_url(object.thumbnail.variant(resize: '1000x1000')) if object.thumbnail.attached?
  end

  attribute :url do |object, params|
    object.url if object.public? || params[:include_url]
  end
end
