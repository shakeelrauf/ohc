# frozen_string_literal: true

FactoryBot.define do
  factory :child, class: 'User::Child', parent: :user do
    avatar { generate(:string) }

    trait :preregistration do
      avatar { nil }

      after :build do |object|
        object.authentication = nil
      end
    end
  end
end
