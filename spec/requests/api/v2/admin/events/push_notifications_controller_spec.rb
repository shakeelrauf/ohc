# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::Events::PushNotificationsController, type: :request do
  let(:admin) { create(:admin) }
  let(:event) { create(:event, tenant: admin.tenant) }

  let(:headers) { auth_headers(admin) }

  describe 'POST #create' do
    let(:example_request) { post "/api/v2/admin/events/#{event.id}/push_notifications", headers: headers }

    before do
      example_request
    end

    it 'responds correctly' do
      expect(response).to have_http_status(:ok)
    end
  end
end
