# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::UsersController, type: :request do
  let(:user) { create(:child) }
  let(:headers) { auth_headers(user) }

  describe '#show' do
    before do
      get '/api/v2/user.json', headers: headers, as: :json
    end

    it { expect(response).to have_http_status(:ok) }
  end

  describe '#update' do
    before do
      patch '/api/v2/user.json', params: jsonapi_packet('user', params), headers: headers, as: :json
    end

    describe 'An user attempting to update their avatar' do
      let(:params) { { avatar: new_avatar_string } }
      let(:new_avatar_string) { 'CHICKEN' }

      it { expect(user.avatar).not_to eq(new_avatar_string) }
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.avatar).to eq(new_avatar_string) }
    end

    describe 'An user attempting to update their live event notification preference' do
      let(:new_live_event_notification_option) { false }
      let(:params) { { live_event_notification: new_live_event_notification_option } }

      it { expect(user.live_event_notification).not_to eq(new_live_event_notification_option) }
      it { expect(response).to have_http_status(:ok) }
      it { expect(user.reload.live_event_notification).to eq(new_live_event_notification_option) }
    end
  end
end
