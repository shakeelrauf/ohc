# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::MessagesController, type: :request do
  include_context 'with cometchat calls'

  let(:message_uid) { generate(:number_as_string) }
  let(:path) { "/api/v2/users/#{user.chat_uid}/messages/#{message_uid}" }
  let(:user) { create(:child) }

  describe 'delete #destroy' do
    let(:admin) { create(:admin) }
    let(:headers) { auth_headers(admin) }

    before { delete path, headers: headers, as: :json }

    context 'with a valid message UID' do
      it { expect(response).to have_http_status(:no_content) }
    end

    context 'with an invalid message UID' do
      let(:message_uid) { invalid_message_uid }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'when child' do
      let(:child) { create(:child) }
      let(:headers) { auth_headers(child) }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
