# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::CreateMediaStoreContainer do
  let(:name) { 'My Container' }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(name) }

  describe '#execute' do
    let(:endpoint) { "https://12345.data.mediastore.#{region}.amazonaws.com" }
    let(:response) { { 'Container': { 'Endpoint': endpoint, 'Status': 'ACTIVE' } } }

    before do
      WebMock.stub_request(:post, "https://mediastore.#{region}.amazonaws.com/")
             .to_return(status: 200, body: response.to_json.to_s, headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
      expect(result.container.endpoint).to eq(endpoint)
    end
  end
end
