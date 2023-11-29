# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::CamperQuestionsController, type: :request do
  let(:child) do
    child = create(:child)

    create(:attendance, user: child)

    child
  end
  let(:headers) { auth_headers(child) }

  describe 'A child retrieving their asked questions' do
    let!(:unanswered_camper_question) { create(:camper_question, child: child) }
    let!(:camper_questions) do
      questions = create_list(:camper_question, 1, :with_reply, child: child)
      questions << create(:camper_question, :with_reply, child: child, read: true)
    end
    let(:example_request) do
      create(:camper_question)

      get '/api/v2/camper_questions.json', headers: headers, as: :json
    end

    before { example_request }

    it 'contains the right ids' do
      response_ids = response_json['data'].map { |question| question['id'].to_i }
      all_user_question_ids = [unanswered_camper_question.id] + camper_questions.map(&:id)

      expect(response_ids).to eq(all_user_question_ids)
    end

    it { expect(camper_questions.all? { |question| question.reload.read }).to eq(true) }
    it { expect(unanswered_camper_question.reload.read).to eq(false) }
  end

  describe 'A child submitting a question' do
    let(:question_text) { 'What is lent?' }

    let(:example_request) do
      post '/api/v2/camper_questions.json', params: jsonapi_packet('camper_question', text: question_text), headers: headers, as: :json
    end

    before do
      create_list(:child, 2)
    end

    it 'has a response status of created' do
      example_request

      expect(response).to have_http_status(:created)
    end

    it 'creates a question in the database' do
      expect { example_request }.to change(CamperQuestion, :count).by(1)
    end

    it 'creates a question in the database for the user of request' do
      example_request
      expect(child.camper_questions.size).not_to eq(0)
    end

    it 'sends an email' do
      expect { example_request }.to(have_enqueued_job.on_queue('mailers'))
    end

    it 'assigns the users last attendance' do
      attendances = create_list(:attendance, 2, user: child)

      example_request

      expect(CamperQuestion.last.attendance).to eq(attendances.last)
    end

    context 'when admin' do
      let(:admin) { create(:admin) }
      let(:headers) { auth_headers(admin) }

      before { example_request }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'with a blank question' do
      let(:question_text) { '' }

      before { example_request }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'Retrieving questions by child' do
    let!(:camper_questions) { create_list(:camper_question, 1, child: child) }

    let(:example_request) { get '/api/v2/camper_questions.json', headers: headers, as: :json }

    before do
      create_list(:camper_question, 2)
      example_request
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_json['data'].map { |camper_question| camper_question['id'].to_i }).to eq(camper_questions.pluck(:id)) }
  end

  describe 'A child checking for unread messages' do
    let(:example_request) { get '/api/v2/camper_questions/unread.json', headers: headers, as: :json }

    context 'when they have no answered messages' do
      before do
        create_list(:camper_question, 2, child: child)
        example_request
      end

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when they have an unread answered message' do
      before do
        create(:camper_question, :with_reply, child: child, read: false)
        create(:camper_question, :with_reply, child: child, read: true)
        example_request
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context 'when they dont have an unread answered message' do
      before do
        create(:camper_question, :with_reply, child: child, read: true)
        example_request
      end

      it { expect(response).to have_http_status(:no_content) }
    end

    context 'when admin' do
      let(:admin) { create(:admin) }
      let(:headers) { auth_headers(admin) }

      before { example_request }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
