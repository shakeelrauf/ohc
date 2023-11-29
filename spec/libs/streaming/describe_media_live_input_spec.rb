# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::DescribeMediaLiveInput do
  let(:input_id) { SecureRandom.hex(2) }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(input_id) }

  describe '#execute' do
    let(:id) { 'abc123' }
    let(:response) { { id: id } }

    before do
      WebMock.stub_request(:get, "https://medialive.#{region}.amazonaws.com/prod/inputs/#{input_id}")
             .to_return(status: 200, body: response.to_json.to_s, headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
      expect(result.id).to eq(id)
    end
  end
end
