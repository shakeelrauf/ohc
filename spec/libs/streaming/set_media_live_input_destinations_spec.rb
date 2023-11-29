# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::SetMediaLiveInputDestinations do
  let(:input_id) { SecureRandom.hex(2) }
  let(:key) { SecureRandom.hex(20) }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(input_id, key) }

  describe '#execute' do
    let(:id) { 'abc123' }
    let(:response) { { input: { id: id } } }

    before do
      WebMock.stub_request(:put, "https://medialive.#{region}.amazonaws.com/prod/inputs/#{input_id}")
             .to_return(status: 200, body: response.to_json.to_s, headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
      expect(result.input.id).to eq(id)
    end
  end
end
