# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::VersionController, type: :request do
  describe 'Retrieve an index of themes' do
    let(:setting) { Setting.find_or_create_by(name: Rails.application.secrets.minimum_app_version_setting_name, value: Rails.application.secrets.minimum_app_version) }
    let(:example_request) { get '/api/v1/version.json', as: :json }

    before do
      example_request
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_json['data']['attributes']['value']).to eq(setting.value) }
  end
end
