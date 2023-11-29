# frozen_string_literal: true

FactoryBot.define do
  factory :color_theme do
    name { generate(:string) }

    app_layout { 'faith_spark' }
    primary_color { '#ffffff' }
    secondary_color { '#000000' }
  end
end
