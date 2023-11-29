# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { create(:child) }
  let(:camper_question) { create(:camper_question, child: user) }
  let(:admin) { create(:admin) }

  describe '.warning' do
    let!(:mail) { described_class.camper_question(admin.email, camper_question, 'test') }

    it 'sends to correct email' do
      expect(mail.to).to eq([admin.email])
    end

    it 'renders the text in the body' do
      expect(mail.body.encoded).to match(camper_question.text)
    end

    it 'renders the user name in the body' do
      expect(mail.body.encoded).to match(user.full_name)
    end
  end
end
