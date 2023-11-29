# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    # NOTE: These don't really need to be before each,
    # but RSpec doesn't allow doubles outside of the per-test lifecycle.
    allow(Cometchat::AuthToken).to receive(:create) { OpenStruct.new(uid: 'UID', auth_token: 'AUTH_TOKEN') }
  end
end
