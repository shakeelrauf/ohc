# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Users::ConversationsController, type: :request do
  include_context 'with cometchat calls'

  let(:child) { create(:child) }
  let(:headers) { auth_headers(child) }

  describe 'A user retrieving their conversations' do
    let(:example_request) do
      get '/api/v2/users/conversations.json', headers: headers, as: :json
    end

    before { example_request }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_json['data'].map { |conv| conv['id'].to_i }).to eq([conversation_id]) }
  end
end
