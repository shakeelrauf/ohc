# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactUsMailer, type: :mailer do
  let(:user) { create(:child) }
  let(:contact_email) { create(:contact_email_message, user: user) }

  let!(:mail) { described_class.contact_us(contact_email, user) }

  context 'with Contact Address preset' do
    it 'renders the subject' do
      expect(mail.subject).to match(contact_email.identifier)
    end

    it 'sends to correct email' do
      expect(mail.to).to eq(Setting.contact_email_addresses)
    end

    it 'renders the text in the body' do
      expect(mail.body.encoded).to match(contact_email.text)
    end

    it 'renders the user name in the body' do
      expect(mail.body.encoded).to match(user.first_name)
      expect(mail.body.encoded).to match(user.last_name)
    end

    it 'renders the user email in the body' do
      expect(mail.body.encoded).to match(user.email)
    end
  end
end
