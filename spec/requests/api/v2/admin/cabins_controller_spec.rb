# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::CabinsController, type: :request do
  describe 'Retrieve an index of cabins' do
    let(:admin) { create(:admin) }
    let(:headers) { auth_headers(admin) }

    let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
    let(:camp) { create(:camp, camp_location: camp_location) }
    let(:female_cabins) { create_list(:cabin, 2, camp: camp, gender: 'female') }
    let(:male_cabins) { create_list(:cabin, 2, camp: camp, gender: 'male') }
    let!(:all_cabins) { female_cabins + male_cabins }

    let(:example_request) { get "/api/v2/admin/camps/#{camp.id}/cabins.json", headers: headers, as: :json }

    before do
      example_request
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_json['data'].map { |cabin| cabin['id'].to_i }).to eq(all_cabins.pluck(:id)) }

    context 'when filtered by gender' do
      let(:example_request) do
        get "/api/v2/admin/camps/#{camp.id}/cabins.json?filter[gender]=female", headers: headers, as: :json
      end

      before do
        create(:cabin, camp: camp, gender: 'male')
      end

      it { expect(response_json['data'].map { |cabin| cabin['id'].to_i }).to eq(female_cabins.pluck(:id)) }
    end
  end
end
