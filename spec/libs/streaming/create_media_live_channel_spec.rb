# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::CreateMediaLiveChannel do
  let(:name) { 'My Input' }
  let(:input_id) { SecureRandom.hex(2) }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(name, input_id) }

  describe '#execute' do
    let(:id) { 'abc123' }
    let(:response) { { channel: { id: id } } }

    before do
      WebMock.stub_request(:post, "https://medialive.#{region}.amazonaws.com/prod/channels")
             .to_return(status: 200, body: response.to_json.to_s, headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
      expect(result.channel.id).to eq(id)
    end
  end
end
