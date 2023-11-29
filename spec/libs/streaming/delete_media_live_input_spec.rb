# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Streaming::DeleteMediaLiveInput do
  let(:input_id) { SecureRandom.hex(2) }
  let(:region) { Rails.application.secrets.media_live[:region] }
  let(:instance) { described_class.new(input_id) }

  describe '#execute' do
    let(:id) { 'abc123' }

    before do
      WebMock.stub_request(:delete, "https://medialive.#{region}.amazonaws.com/prod/inputs/#{input_id}")
             .to_return(status: 200, body: '', headers: {})
    end

    it 'returns the expected result' do
      result = instance.execute

      expect(result).to be_a(Seahorse::Client::Response)
    end
  end
end
