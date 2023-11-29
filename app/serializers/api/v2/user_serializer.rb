# frozen_string_literal: true

class API::V2::UserSerializer < API::V2::ApplicationSerializer
  set_type :user

  belongs_to :device_token, serializer: API::V2::DeviceTokenSerializer
  belongs_to :tenant, serializer: API::V2::TenantSerializer

  has_many :attendances, serializer: API::V2::AttendanceSerializer, id_method_name: :attendance_codes
  has_many :cabins, serializer: API::V2::CabinSerializer
  has_many :camps, serializer: API::V2::CampSerializer
  has_many :camp_locations, serializer: API::V2::CampLocationSerializer

  attributes :avatar,
             :chat_uid,
             :created_at,
             :date_of_birth,
             :email,
             :first_name,
             :gender,
             :last_name,
             :updated_at

  attribute(:role) { |user| user.child? ? 'child' : user.role }

  attribute(:registered, &:registered?)
end
