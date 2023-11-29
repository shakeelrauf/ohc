# frozen_string_literal: true

class API::V2::AttendanceSerializer < API::V2::ApplicationSerializer
  set_type :attendance
  set_id :code

  belongs_to :camp
  belongs_to :user

  attributes :created_at, :updated_at

  attributes :tenant_id do |object|
    object.user.tenant_id
  end
end
