# frozen_string_literal: true

FactoryBot.define do
  factory :admin, aliases: [:super_admin], class: 'User::Admin', parent: :user do
    role { 'super_admin' }

    factory :tenant_admin do
      role { 'tenant_admin' }
    end

    factory :camp_admin do
      role { 'camp_admin' }

      camp_location

      factory :cabin_admin do
        role { 'cabin_admin' }
      end
    end
  end
end
