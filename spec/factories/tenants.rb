# frozen_string_literal: true

FactoryBot.define do
  factory :tenant do
    name { generate(:string) }
    max_users { 999 }
    max_streams { 5 }
    max_stream_hours { 5 }

    association :color_theme
  end
end
