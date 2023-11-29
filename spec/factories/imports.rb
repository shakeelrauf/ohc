# frozen_string_literal: true

FactoryBot.define do
  factory :camp_import, class: 'Import' do
    scope { create(:camp) }
    csv_file { fixture_file('Test Sheet - Camp.csv', 'text/csv') }

    association :tenant
  end
end
