# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::CampsController, type: :request do
  describe 'Retrieve a single camp' do
    let(:admin) { create(:admin) }
    let(:headers) { auth_headers(admin) }

    let(:camp) { create(:camp) }
    let(:example_request) { get "/api/v2/admin/camps/#{camp.id}.json", headers: headers, as: :json }

    before do
      example_request
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_json['data']['id'].to_i).to eq(camp.id) }
  end
end
