# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CamperQuestionsController, type: :controller do
  let(:admin) { create(:super_admin) }
  let(:camper_question) { create(:camper_question, tenant: admin.tenant) }

  before { admin_login(admin) }

  it_behaves_like 'index action' do
    before do
      create_list(:camper_question, 2)
    end
  end

  describe 'GET #index' do
    context 'when a Camp Admin' do
      let(:attendance) { create(:attendance, :by_child) }
      let(:admin) { create(:camp_admin, camp_location_id: attendance.camp_location.id) }
      let!(:camper_questions) { create_list(:camper_question, 2, tenant: admin.tenant, attendance: attendance, child: attendance.user) }

      before do
        create_list(:camper_question, 2)

        get :index
      end

      it { expect(assigns(:camper_questions)).to eq(camper_questions) }
    end
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: camper_question.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'I have replied to this question' }
    let(:valid_params) { { id: camper_question.id, camper_question: { reply: new_value } } }
    let(:invalid_params) { { id: camper_question.id, camper_question: { reply: '' } } }
    let(:object) { camper_question }
    let(:attribute) { :reply }
    let(:redirect_path) { camper_questions_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: camper_question.id } }
    let(:redirect_path) { camper_questions_path }
  end
end
