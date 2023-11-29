# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventMailer, type: :mailer do
  let(:event) { create(:event) }
  let(:duration) { 120 }
  let(:to_address) { [event.admin.email] }
  let(:bcc_address) { Setting.alert_email_addresses }

  describe '.warning' do
    let!(:mail) { described_class.warning(event, duration) }

    it 'sends to correct email' do
      expect(mail.to).to eq(to_address)
    end

    it 'bccs the alert emails' do
      expect(mail.bcc).to eq(bcc_address)
    end

    it 'includes the tenant name' do
      expect(mail.body.encoded).to match(event.tenant.name)
      expect(mail.subject).to match(event.tenant.name)
    end
  end

  describe '.stopped' do
    let!(:mail) { described_class.stopped(event, duration) }

    it 'sends to correct email' do
      expect(mail.to).to eq(to_address)
    end

    it 'bccs the alert emails' do
      expect(mail.bcc).to eq(bcc_address)
    end

    it 'includes the tenant name' do
      expect(mail.body.encoded).to match(event.tenant.name)
      expect(mail.subject).to match(event.tenant.name)
    end
  end
end
