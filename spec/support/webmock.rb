# frozen_string_literal: true

RSpec.configure do
  require 'webmock/rspec'

  WebMock.disable_net_connect!(allow_localhost: true)
end
