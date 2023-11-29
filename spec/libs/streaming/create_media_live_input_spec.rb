# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::CreateMediaLiveInput do
  let(:name) { 'My Input' }
  let(:key) { SecureRandom.hex(10) }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(name, key) }

  describe '#execute' do
    let(:id) { 'abc123' }
    let(:response) { { input: { id: id } } }

    before do
      WebMock.stub_request(:post, "https://medialive.#{region}.amazonaws.com/prod/inputs")
             .to_return(status: 200, body: response.to_json.to_s, headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
      expect(result.input.id).to eq(id)
    end
  end
end
