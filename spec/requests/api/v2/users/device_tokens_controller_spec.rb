# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Users::DeviceTokensController, type: :request do
  let(:child) { create(:child) }
  let(:headers) { auth_headers(child) }

  describe 'A child submitting a token' do
    let(:token) { 'DEVICE_TOKEN' }
    let(:device_operating_system) { 'ios' }

    let(:example_request) do
      post '/api/v2/users/device_token.json', params: jsonapi_packet('device_token', token: token, device_operating_system: device_operating_system),
                                              headers: headers,
                                              as: :json
    end

    context 'with ios device type' do
      it 'has a response status of created' do
        example_request
        expect(response).to have_http_status(:created)
      end

      it 'creates a token in the database' do
        expect { example_request }.to change(DeviceToken, :count).by(1)
      end

      it 'creates a token in the database for the user of request' do
        example_request
        expect(child.reload.device_token.present?).not_to eq(false)
      end
    end

    context 'with android device type' do
      let(:device_operating_system) { 'android' }

      it 'has a response status of created' do
        example_request
        expect(response).to have_http_status(:created)
      end

      it 'creates a token in the database' do
        expect { example_request }.to change(DeviceToken, :count).by(1)
      end

      it 'creates a token in the database for the user of request' do
        example_request
        expect(child.reload.device_token.present?).not_to eq(false)
      end
    end

    context 'that already exists' do
      let(:token) { 'DEVICE_TOKEN' }
      let!(:existingToken) { create(:device_token, token: token) }

      it 'has a response status of created' do
        example_request
        expect(response).to have_http_status(:created)
      end

      it 'doesnt create a new token' do
        expect { example_request }.to change(DeviceToken, :count).by(0)
      end
    end

    context 'when admin' do
      let(:admin) { create(:admin) }
      let(:headers) { auth_headers(admin) }

      before { example_request }

      it { expect(response).to have_http_status(:created) }
    end

    context 'with a blank token' do
      let(:token) { '' }

      before { example_request }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'with a blank device type' do
      let(:device_operating_system) { '' }

      before { example_request }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
