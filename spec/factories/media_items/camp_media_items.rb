# frozen_string_literal: true

FactoryBot.define do
  factory :camp_media_item, class: MediaItem::CampMediaItem, parent: :media_item do
    association :camp
  end
end
