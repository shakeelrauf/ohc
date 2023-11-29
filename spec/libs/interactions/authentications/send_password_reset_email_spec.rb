# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interactions::Authentications::SendPasswordResetEmail do
  describe '#execute' do
    let(:tenant) { create(:tenant) }
    let(:authentication) { create(:authentication) }
    let(:user) { create(:child, authentication: authentication, tenant: tenant) }
    let(:email) { user.email }

    let(:interaction) { described_class.new(email, nil) }

    it 'fetches the correct authentications' do
      expect(interaction.send(:authentications)).to eq([authentication])
    end

    it 'sets the correct sender' do
      expect(interaction.send(:sender)).to eq(Rails.application.secrets.email[:from_address])
    end

    it 'sets the correct default_password_link_options' do
      expect(interaction.send(:default_password_link_options)).to eq({})
    end
  end
end
