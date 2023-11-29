# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Authentications::SessionsController, type: :request do
  let(:path) { '/api/v2/authentications/sessions' }
  let(:user) { create(:child) }
  let(:authentication) { user.authentication }

  describe 'A child logging in' do
    it 'succeeds with valid details' do
      post path, params: jsonapi_packet('authentication', username: authentication.username, password: authentication.password), as: :json

      user.reload

      expect(response).to have_http_status(:created)
      expect(user.chat_auth_token).not_to eq(nil)
      expect(response_json['data']['attributes']['authenticationToken']).to eq(authentication.api_session_token.token)
    end

    context 'with users included' do
      it 'includes the correct users' do
        post path, params: jsonapi_packet('authentication', { username: authentication.username, password: authentication.password }, include: 'users'),
                   as: :json

        user_ids = authentication.user_ids
        included_users = response_json['included'].map { |user| user['id'].to_i }

        expect(included_users).to eq(user_ids)
      end
    end

    it 'succeeds if they are already logged in' do
      authentication.ensure_api_token!

      post path, params: jsonapi_packet('authentication', username: authentication.username, password: authentication.password), as: :json

      expect(response).to have_http_status(:created)
      expect(response_json['data']['attributes']['authenticationToken']).to eq(authentication.reload.api_session_token.token)
    end

    it 'fails with invalid details' do
      post path, params: jsonapi_packet('authentication', username: 'bogus', password: 'bogus'), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Username or password is invalid')
    end

    it 'fails gracefully with blank password passed' do
      post path, params: jsonapi_packet('authentication', username: authentication.username, password: ''), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'fails gracefully with blank params passed' do
      post path, params: jsonapi_packet('authentication', username: '', password: ''), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'fails gracefully with no params passed' do
      post path, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'An Admin logging in' do
    let(:user) { create(:admin) }

    it 'succeeds with valid details' do
      post path, params: jsonapi_packet('authentication', username: authentication.username, password: authentication.password), as: :json

      expect(response).to have_http_status(:created)
      expect(response_json['data']['attributes']['authenticationToken']).not_to eq(nil)
    end
  end

  describe 'GET #show' do
    it 'returns the user if valid details are passed' do
      get path, headers: auth_headers(user), as: :json

      expect(response).to have_http_status(:ok)
    end

    context 'with users included' do
      it 'includes the correct users' do
        get "#{path}?include=users", headers: auth_headers(user), as: :json

        user_ids = authentication.user_ids
        included_users = response_json['included'].map { |user| user['id'].to_i }

        expect(included_users).to eq(user_ids)
      end
    end

    it 'correctly errors when bad a authentication token is passed' do
      get path, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'delete #destroy' do
    before { authentication.ensure_api_token! }

    it 'removes the authentication_token' do
      delete path, headers: auth_headers(user), as: :json

      expect(response).to have_http_status(:no_content)
      expect(authentication.reload.api_session_token).to eq(nil)
    end
  end
end
