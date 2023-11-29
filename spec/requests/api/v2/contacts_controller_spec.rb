# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::ContactsController, type: :request do
  let(:child) { create(:child) }
  let(:headers) { auth_headers(child) }

  describe 'a user submitting text to contact us' do
    let(:contact_text) { 'What is lent?' }
    let(:example_request) do
      post '/api/v2/contact.json', params: jsonapi_packet('contact', text: contact_text), headers: headers, as: :json
    end

    it 'has a response status of created' do
      example_request
      expect(response).to have_http_status(:created)
    end

    it 'creates an email query in the database' do
      expect { example_request }.to change(ContactEmailMessage, :count).by(1)
    end

    it 'sends the an email', skip_request: true do
      expect { example_request }.to(have_enqueued_job.on_queue('mailers'))
    end
  end
end
