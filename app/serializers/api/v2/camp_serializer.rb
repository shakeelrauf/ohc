# frozen_string_literal: true

class API::V2::CampSerializer < API::V2::ApplicationSerializer
  include Video

  set_type :camp

  has_many :attendances, id_method_name: :attendance_codes
  has_many :cabins
  has_one :camp_location
  has_one :season

  attributes :name, :chat_guid
end
