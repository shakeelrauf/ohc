# frozen_string_literal: true

FactoryBot.define do
  sequence :string do |n|
    "string#{n}"
  end

  sequence(:number_as_string, &:to_s)

  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :boolean do
    [true, false].sample
  end
end
