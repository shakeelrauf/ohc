# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TenantMailer, type: :mailer do
  let(:tenant) { create(:tenant) }

  describe '.warning' do
    let!(:mail) { described_class.warning(tenant) }

    it 'sends to correct email' do
      expect(mail.to).to eq(Setting.alert_email_addresses)
    end
  end
end
