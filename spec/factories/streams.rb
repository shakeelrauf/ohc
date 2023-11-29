# frozen_string_literal: true

FactoryBot.define do
  factory :stream do
    name { generate(:string) }
    aws_input_id { SecureRandom.hex(5) }
    aws_channel_id { SecureRandom.hex(5) }

    after(:build) do |stream|
      WebMock.stub_request(:post, 'https://medialive.eu-west-1.amazonaws.com/prod/inputs')
             .to_return(status: 200, body: { input: { id: stream.aws_input_id } }.to_json.to_s, headers: {})

      WebMock.stub_request(:post, 'https://medialive.eu-west-1.amazonaws.com/prod/channels')
             .to_return(status: 200, body: { channel: { id: stream.aws_channel_id, status: 'IDLE' } }.to_json.to_s, headers: {})

      WebMock.stub_request(:get, "https://medialive.eu-west-1.amazonaws.com/prod/channels/#{stream.aws_channel_id}")
             .to_return(status: 200, body: { id: stream.aws_channel_id, state: 'IDLE' }.to_json.to_s, headers: {})

      WebMock.stub_request(:delete, "https://medialive.eu-west-1.amazonaws.com/prod/inputs/#{stream.aws_input_id}")
             .to_return(status: 200, body: '', headers: {})

      WebMock.stub_request(:delete, "https://medialive.eu-west-1.amazonaws.com/prod/channels/#{stream.aws_channel_id}")
             .to_return(status: 200, body: { id: stream.aws_channel_id, state: 'IDLE' }.to_json.to_s, headers: {})
    end

    trait :with_start do
      after(:build) do |stream|
        WebMock.stub_request(:put, "https://medialive.eu-west-1.amazonaws.com/prod/inputs/#{stream.aws_input_id}")
               .to_return(status: 200, body: { id: stream.aws_input_id }.to_json.to_s, headers: {})

        WebMock.stub_request(:put, "https://medialive.eu-west-1.amazonaws.com/prod/channels/#{stream.aws_channel_id}")
               .to_return(status: 200, body: { id: stream.aws_channel_id, state: 'IDLE' }.to_json.to_s, headers: {})

        WebMock.stub_request(:post, "https://medialive.eu-west-1.amazonaws.com/prod/channels/#{stream.aws_channel_id}/start")
               .to_return(status: 200, body: { id: stream.aws_channel_id, state: 'STARTING' }.to_json.to_s, headers: {})
      end
    end

    trait :with_stop do
      after(:build) do |stream|
        WebMock.stub_request(:post, "https://medialive.eu-west-1.amazonaws.com/prod/channels/#{stream.aws_channel_id}/stop")
               .to_return(status: 200, body: { id: stream.aws_channel_id, state: 'STOPPING' }.to_json.to_s, headers: {})
      end
    end
  end
end
