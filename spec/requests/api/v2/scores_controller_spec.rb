# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::ScoresController, type: :request do
  let(:user) { create(:child) }
  let(:scope) { create(:theme) }
  let(:value) { 100 }

  describe 'A single score being submitted' do
    let(:example_request) do
      post('/api/v2/scores.json', headers: auth_headers(user), params: params, as: :json)
    end

    let(:params) do
      jsonapi_packet('score',
                     { value: value },
                     relationships: { scope: { data: jsonapi_ref_object(scope.class.name.underscore, scope.id) } })
    end

    context 'with request' do
      before { example_request }

      it { expect(response_json.dig('data', 'id')).to eq(scope.scores.first.id.to_s) }
      it { expect(response_json.dig('data', 'relationships', 'scope', 'data', 'id')).to eq(scope.id.to_s) }
      it { expect(response_json.dig('data', 'relationships', 'scope', 'data', 'type')).to eq('theme') }
    end

    context 'with a Theme as its scope' do
      it { expect { example_request }.to change(Score, :count).by(1) }

      it 'assigns the correct user' do
        example_request

        expect(user.scores).to eq(Score.all)
      end

      it 'assigns the correct scope' do
        example_request

        expect(scope.scores).to eq(Score.all)
      end

      it 'assigns the correct value' do
        example_request

        expect(Score.first.value).to eq(value)
      end
    end

    context 'with a QuizQuestion as its scope' do
      let(:scope) { create(:quiz_question) }

      it 'assigns the correct scope' do
        example_request

        expect(scope.scores).to eq(Score.all)
      end
    end

    context 'with a negative value' do
      let(:value) { -10 }

      before { example_request }

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(response_json['errors'].first['detail']).to eq('Value must be greater than or equal to 0') }
    end
  end

  describe 'An array of scores being submitted' do
    let(:example_request) do
      post('/api/v2/scores.json', headers: auth_headers(user), params: params, as: :json)
    end

    let(:second_value) { 4 }
    let(:second_scope) { create(:quiz_question) }

    let(:params) do
      theme_score = jsonapi_object('score',
                                   { value: value },
                                   relationships: {
                                     scope: { data: jsonapi_ref_object(scope.class.name.underscore, scope.id) }
                                   })
      question_score = jsonapi_object('score',
                                      { value: second_value },
                                      relationships: {
                                        scope: {
                                          data: jsonapi_ref_object(second_scope.class.name.underscore, second_scope.id)
                                        }
                                      })

      jsonapi_packet(nil, nil, data: [theme_score, question_score])
    end

    it { expect { example_request }.to change(Score, :count).by(2) }
    it { expect { example_request }.to change(scope.scores, :count).by(1) }
    it { expect { example_request }.to change(second_scope.scores, :count).by(1) }

    context 'with request' do
      before { example_request }

      it { expect(user.scores).to eq(Score.all) }
      it { expect(Score.first.value).to eq(value) }
      it { expect(Score.second.value).to eq(second_value) }
      it { expect(response_json.dig('data', 'id')).to eq(scope.scores.first.id.to_s) }
      it { expect(response_json.dig('data', 'relationships', 'scope', 'data', 'id')).to eq(scope.id.to_s) }
      it { expect(response_json.dig('data', 'relationships', 'scope', 'data', 'type')).to eq('theme') }
    end

    context 'with an empty array' do
      let(:params) { jsonapi_packet(nil, nil, data: []) }

      it { expect { example_request }.not_to change(Score, :count) }

      it 'responds with unprocessable entity' do
        example_request

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'returns highscore for the theme' do
      let(:high_score) { 1000 }

      before do
        create(:score, scope: scope, user: user, value: high_score)

        example_request
      end

      it { expect(response_json['data']['attributes']['value']).to eq(high_score) }
    end
  end

  describe 'Fetching highscores for a user' do
    let(:child) { create(:child) }

    let(:theme) { create(:theme) }
    let(:question_scope) { create(:quiz_question, theme: theme) }
    let(:low_score) { 10 }
    let(:high_score) { 20 }

    let(:headers) { auth_headers(child) }
    let(:example_request) { get '/api/v2/scores.json', headers: headers, as: :json }

    context 'gets the highest score for a theme' do
      before do
        # Create some questions scores
        create_list(:score, 2, scope: question_scope, user: child)

        # Create some theme scores
        create(:score, scope: theme, user: child, value: low_score)
        create(:score, scope: theme, user: child, value: high_score)

        # Do request
        example_request
      end

      it { expect(response_json['data'].first['attributes']['value']).to eq(high_score) }
      it { expect(response_json['data'].first['attributes']['scopeId']).to eq(theme.id) }
    end

    context 'doesnt return inactive themes' do
      let(:theme) { create(:theme, active: false) }

      before do
        # Create some questions scores
        create_list(:score, 2, scope: question_scope, user: child)

        # Create some theme scores
        create(:score, scope: theme, user: child, value: low_score)
        create(:score, scope: theme, user: child, value: high_score)

        # Do request
        example_request
      end

      it { expect(response_json['data']).to be_empty }
    end

    context 'doesnt return another users scores' do
      let(:another_child) { create(:child) }

      before do
        # Create some questions scores
        create_list(:score, 2, scope: question_scope, user: child)

        # Create some theme scores
        create(:score, scope: theme, user: child, value: low_score)
        create(:score, scope: theme, user: another_child, value: high_score)

        # Do request
        example_request
      end

      it { expect(response_json['data'].first['attributes']['value']).to eq(low_score) }
    end
  end
end
