# frozen_string_literal: true

FactoryBot.define do
  factory :welcome_video do
    name { generate(:string) }
    video { fixture_file('fixture.mp4', 'video/mp4') }

    association :tenant
  end
end
