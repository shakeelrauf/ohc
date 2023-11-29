# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::ThemesController, type: :request do
  describe 'Retrieve an index of themes' do
    let(:child) { create(:child) }
    let(:attendance) { create(:attendance, user: child) }

    let(:national_themes) { create_list(:theme, 2, tenant: child.tenant) }
    let(:camp_location_themes) { create_list(:theme, 2, tenant: child.tenant, camp_location_id: attendance.camp.camp_location_id) }
    let(:other_camp_location_themes) { create_list(:theme, 2, tenant: child.tenant, camp_location_id: create(:camp_location).id) }

    let(:example_request) { get '/api/v2/themes.json', headers: auth_headers(child), as: :json }

    before do
      national_themes
      camp_location_themes
      other_camp_location_themes

      example_request
    end

    it { expect(response).to have_http_status(:ok) }

    it 'returns any national themes' do
      expect(response_json['data'].map { |theme| theme['id'].to_i }).to include(*national_themes.map(&:id))
    end

    it 'returns any themes for my camp' do
      expect(response_json['data'].map { |theme| theme['id'].to_i }).to include(*camp_location_themes.map(&:id))
    end

    it 'excludes themes for other camp locations' do
      expect(response_json['data'].map { |theme| theme['id'].to_i }).not_to include(*other_camp_location_themes.map(&:id))
    end

    it 'excludes any inactive themes' do
      inactive_themes = create_list(:theme, 2, active: false)

      expect(response_json['data'].map { |theme| theme['id'].to_i }).not_to include(*inactive_themes.map(&:id))
    end
  end
end
