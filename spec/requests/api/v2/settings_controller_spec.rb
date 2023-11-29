# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::SettingsController, type: :request do
  describe 'Retrieve an index of settings' do
    let(:example_request) { get '/api/v2/settings.json', as: :json }

    before do
      example_request
    end

    it { expect(response).to have_http_status(:ok) }

    it 'contains all visible settings' do
      setting_values = Setting.visible.pluck(:value)
      response_setting_values = response_json['data'].map { |setting| setting.dig('attributes', 'value') }

      expect(setting_values).to eq(response_setting_values)
    end

    it 'contains excludes hidden settings' do
      setting_values = Setting.hidden.pluck(:value)
      response_setting_values = response_json['data'].map { |setting| setting.dig('attributes', 'value') }

      expect(setting_values).not_to eq(response_setting_values)
    end
  end
end
