# frozen_string_literal: true

class API::V2::CustomLabelSerializer < API::V2::ApplicationSerializer
  set_type :custom_label

  attributes :class_name, :locale, :singular, :plural

  attribute :name do |object|
    # 'MediaItem::CampMediaItem' > 'campMediaItem'
    object.class_name.demodulize.camelcase(:lower)
  end
end
