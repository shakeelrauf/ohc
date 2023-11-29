# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::StreamsController, type: :request do
  let(:admin) { create(:admin) }
  let(:headers) { auth_headers(admin) }

  let(:event) { create(:event) }
  let(:allocated_streams) { create_list(:stream, 2, event: event) }
  let(:unallocated_streams) { create_list(:stream, 2) }

  describe 'GET #create' do
    let(:example_request) { get '/api/v2/admin/streams', headers: headers }

    before do
      allocated_streams
      unallocated_streams
      example_request
    end

    it 'responds correctly' do
      expect(response).to have_http_status(:ok)
    end

    it 'only responds with unallocated streams' do
      expect(response_json['data'].size).to eq(unallocated_streams.size)
    end
  end
end
