# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe '.reset_multiple' do
    let(:admin) { create(:admin) }
    let(:children) { create_list(:child, 3, email: admin.email) }
    let(:sender) { Rails.application.secrets.email[:from_address] }

    let(:registered) do
      authentications = children.collect(&:authentication) << admin.authentication

      authentications.map do |authentication|
        authentication.ensure_reset_token!

        link = edit_password_url(authentication, reset_token: authentication.password_reset_token.token)

        {
          label: authentication.username,
          link: link
        }
      end
    end

    let(:unregistered) do
      create_list(:attendance, 2).map do |attendance|
        {
          label: "#{attendance.camp_location.name} - #{attendance.camp.name}",
          code: attendance.code
        }
      end
    end

    let!(:mail) { described_class.reset_multiple(sender, admin.email, registered, unregistered) }

    it { expect(mail.subject).to eq(I18n.t('password_mailer.reset_multiple.subject')) }
    it { expect(mail.to).to eq([admin.email]) }
    it { expect(mail.from).to eq([sender]) }
    it { expect(mail.reply_to).to eq([Rails.application.secrets.email[:from_address]]) }

    it do
      registered.each do |data|
        expect(mail.text_part.body).to include(data[:link])
      end
    end

    it do
      unregistered.each do |data|
        expect(mail.text_part.body).to include(data[:code])
      end
    end
  end
end
