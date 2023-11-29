# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::QuizQuestionsController, type: :request do
  describe 'Retrieve an index of quiz questions' do
    let(:theme) { create(:theme) }
    let!(:quiz_questions) { create_list(:quiz_question, 2, theme: theme) }

    let(:path) { "/api/v2/themes/#{theme.id}/quiz_questions.json" }
    let(:example_request) { get path, headers: auth_headers, as: :json }

    before do
      example_request
    end

    it { expect(response).to have_http_status(:ok) }

    it 'contains the appropriate questions' do
      response_question_ids = response_json['data'].map { |quiz_question| quiz_question['id'].to_i }

      expect(response_question_ids).to eq(quiz_questions.pluck(:id))
    end

    context 'with included answers' do
      let(:quiz_questions) { create_list(:quiz_question, 2, theme: theme) }
      let(:path) { "/api/v2/themes/#{theme.id}/quiz_questions.json?include=answers" }

      it 'includes the correct answers' do
        included_answer_ids = response_json['included'].map { |answer| answer['id'] }
        question_answer_ids = quiz_questions.map { |quiz_question| quiz_question.answer_ids.map(&:to_s) }.flatten

        expect(included_answer_ids).to eq(question_answer_ids)
      end
    end
  end
end
