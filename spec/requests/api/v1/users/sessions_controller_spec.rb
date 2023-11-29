# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Users::SessionsController, type: :request do
  let(:path) { '/api/v1/users/sessions' }
  let(:user) { create(:child) }
  let(:authentication) { user.authentication }

  describe 'GET #show' do
    it 'returns unauthorized regardless of correct headers as api is deprecated' do
      get path, headers: auth_headers(user), as: :json

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorised when no headers are passed' do
      get path, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'delete #destroy' do
    it 'removes the authentication_token' do
      delete path, as: :json

      expect(response).to have_http_status(:no_content)
    end
  end
end
