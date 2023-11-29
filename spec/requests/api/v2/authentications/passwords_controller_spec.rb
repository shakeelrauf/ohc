# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Authentications::PasswordsController, type: :request do
  let(:user) { create(:child) }
  let(:authentication) { user.authentication }

  before do
    authentication.ensure_reset_token!
  end

  describe 'an authentication submitting their email address to receive a reset email' do
    let(:params) { { email: user.email } }
    let(:example_request) { post '/api/v2/authentications/passwords', params: jsonapi_packet('authentication', params), as: :json }

    before do |example|
      example_request unless example.metadata[:skip_request].present?
    end

    context 'with a recognised child email' do
      it { expect(response).to have_http_status(:ok) }
    end

    context 'with a recognised admin email' do
      let(:user) { create(:admin) }

      it { expect(response).to have_http_status(:ok) }
    end

    context 'with a recognised admin email with children' do
      let(:user) { create(:admin) }

      before do
        children = create_list(:child, 2, email: user.email)
      end

      it 'sends the password reset email', skip_request: true do
        expect { example_request }.to have_enqueued_job.on_queue('mailers')
      end

      it 'returns 201' do
        expect(response).to have_http_status(:ok)
      end
    end

    # To stop the ability to enumerate email addresses the password reset
    # facility always returns a 201 and a ambiguous message.
    context 'with an invalid email' do
      let(:params) { { email: 'bogus@example.com' } }

      it 'returns 201' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with no email' do
      let(:params) { {} }

      it 'returns 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #show' do
    context 'when valid reset token' do
      it 'returns 200' do
        get "/api/v2/authentications/passwords/#{authentication.password_reset_token.token}", as: :json

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid reset token' do
      it 'returns 404' do
        get '/api/v2/authentications/passwords/invalidtoken', as: :json

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when valid password' do
      let(:new_password) { 'NewPassword123!' }
      let(:params) { { password: new_password } }

      before do
        patch "/api/v2/authentications/passwords/#{authentication.password_reset_token.token}", params: jsonapi_packet('authentication', params), as: :json
      end

      it 'returns 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'sets the users authentication token' do
        expect(authentication.reload.authenticate(new_password)).not_to eq(false)
      end

      it 'nullifys the users reset token' do
        expect(authentication.reload.password_reset_token).to be_nil
      end
    end

    context 'when validation error' do
      let(:params) { { password: 'a' } }

      before do
        patch "/api/v2/authentications/passwords/#{authentication.password_reset_token.token}", params: jsonapi_packet('authentication', params), as: :json
      end

      it 'returns 422' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'contains validation errors' do
        expect(response.body).to include('Password is too short (minimum is 6 characters)')
      end
    end
  end
end
