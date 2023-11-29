# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::AuthenticationsController, type: :request do
  describe 'POST #create' do
    let(:path) { '/api/v2/authentications?include=users' }
    let(:attendance) { create(:attendance, user: create(:child, authentication: nil)) }
    let(:new_authentication_params) { attributes_for(:authentication) }
    let(:valid_params) { new_authentication_params.merge(code: attendance.code, dob: attendance.user.date_of_birth.to_s) }

    context 'with valid username' do
      before { post path, params: jsonapi_packet('authentication', valid_params), as: :json }

      it { expect(response).to have_http_status(:created) }
      it { expect(response_json['data']['attributes']['authenticationToken']).not_to eq(nil) }
    end

    context 'when username is uppercase' do
      before do
        create(:authentication, username: new_authentication_params)
        post path, params: jsonapi_packet('authentication', params), as: :json
      end

      let(:params) do
        valid_params.merge(username: new_authentication_params[:username].upcase,
                           password: new_authentication_params[:password])
      end

      it { expect(response).to have_http_status(:created) }
    end

    context 'with no password passed' do
      let(:params) { valid_params.except(:password) }

      before { post path, params: jsonapi_packet('authentication', params), as: :json }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response.body).to include("Password can't be blank") }
    end

    it 'fails gracefully with no params passed' do
      post path, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#check_username' do
    describe 'Checking an authentications username is taken' do
      let(:params) { { username: username } }
      let(:example_request) { get '/api/v2/authentications/check_username.json', params: params, as: :json }

      before do
        example_request
      end

      context 'when taken' do
        let(:authentication) { create(:authentication) }
        let(:username) { authentication.username }

        it { expect(Authentication.exists?(username: username)).to eq(true) }
        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'when not taken' do
        let(:username) { 'test' }

        it { expect(Authentication.exists?(username: username)).to eq(false) }
        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end
