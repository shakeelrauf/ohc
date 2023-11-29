# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::SeasonsController, type: :request do
  describe 'Retrieve an index of seasons' do
    let(:camp_location) { create(:camp_location) }
    let!(:seasons) { create_list(:season, 2, camp_location: camp_location) }
    let(:headers) { auth_headers(user) }
    let(:example_request) { get '/api/v2/admin/seasons.json', headers: headers, as: :json }

    context 'Given a super user wants to view the list of seasons' do
      let(:user) { create(:admin, tenant: camp_location.tenant) }

      context 'when they make a request for those seasons' do
        before { example_request }

        it 'then responds with all seasons, newest first' do
          expect(response).to have_http_status(:ok)
          expect(response_json['data'].map { |season| season['id'].to_i }).to eq(seasons.pluck(:id).reverse)
          expect(response_json['data'].map { |season| season['attributes']['name'] }).to eq(seasons.pluck(:name).reverse)
        end
      end
    end

    context 'Given a camp admin wants to view the list of seasons' do
      let(:user) { create(:camp_admin, tenant: camp_location.tenant, camp_location: camp_location) }

      context 'when they make a request for those seasons' do
        before { example_request }

        it 'then responds with all seasons associated with their camp location, newest first' do
          expect(response).to have_http_status(:ok)
          expect(response_json['data'].map { |season| season['id'].to_i }).to eq(seasons.pluck(:id).reverse)
          expect(response_json['data'].map { |season| season['attributes']['name'] }).to eq(seasons.pluck(:name).reverse)
        end
      end
    end

    context 'Given a cabin admin wants to view the list of seasons' do
      let(:user) { create(:cabin_admin, tenant: camp_location.tenant) }

      context 'when they make a request for those seasons' do
        before { example_request }

        it 'then responds with no seasons' do
          expect(response).to have_http_status(:ok)
          expect(response_json['data']).to be_empty
        end
      end
    end
  end
end
