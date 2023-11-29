# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::SetMediaLiveChannelDestinations do
  let(:channel_id) { SecureRandom.hex(2) }
  let(:path_name) { 'example-path' }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(channel_id, path_name) }

  describe '#execute' do
    let(:id) { 'abc123' }
    let(:response) { { channel: { id: id } } }

    before do
      WebMock.stub_request(:put, "https://medialive.#{region}.amazonaws.com/prod/channels/#{channel_id}")
             .to_return(status: 200, body: response.to_json.to_s, headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
      expect(result.channel.id).to eq(id)
    end
  end
end
