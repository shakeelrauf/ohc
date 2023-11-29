# frozen_string_literal: true

class API::V1::SettingSerializer < API::V1::ApplicationSerializer
  set_type :setting

  attributes :name, :value, :updated_at
end
