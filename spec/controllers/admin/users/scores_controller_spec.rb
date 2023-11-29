# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::ScoresController, type: :controller do
  let(:admin) { create(:admin) }

  before { admin_login(admin) }

  describe 'GET #index' do
    let(:child) { create(:child, tenant: admin.tenant) }
    let(:params) { { user_id: child.id } }
    let!(:theme_scores) { create_list(:score, 3, :for_theme, user: child) }

    it_behaves_like 'index action' do
      before do
        theme_scores.each do |theme_score|
          scope = create(:quiz_question, theme: theme_score.scope)
          create_list(:score, 2, user: child, scope: scope)
        end
      end
    end

    it 'assigns the correct scores' do
      get(:index, params: params)

      scores_hash = theme_scores.each_with_object({}) do |theme_score, hash|
        hash[theme_score.scope] = theme_score
      end

      expect(assigns(:scores)).to eq(scores_hash)
    end
  end
end
