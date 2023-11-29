# frozen_string_literal: true

class API::V2::SettingSerializer < API::V2::ApplicationSerializer
  set_type :setting

  attributes :name, :value, :updated_at
end
