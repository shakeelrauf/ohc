# frozen_string_literal: true

require 'rails_helper'

shared_examples 'index action' do
  describe 'GET #index' do
    let(:optional_params) { defined?(params) ? params : {} }
    let(:request_example) { get :index, params: optional_params }

    it { expect(request_example).to render_template(:index) }

    it_behaves_like 'requires an authenticated user'
  end
end

shared_examples 'new action' do
  describe 'GET #new' do
    let(:optional_params) { defined?(params) ? params : {} }
    let(:request_example) { get :new, params: optional_params }

    it { expect(request_example).to render_template(:new) }

    it_behaves_like 'requires an authenticated user'
  end
end

shared_examples 'create action' do
  describe 'POST #create' do
    let(:params) { {} }
    let(:request_example) { post :create, params: params }

    context 'with valid params' do
      before { request_example }

      let(:params) { valid_params }

      it { is_expected.to redirect_to(redirect_path) }
    end

    context 'with invalid params' do
      before { request_example }

      let(:params) { invalid_params }

      it { is_expected.to render_template(:new) }
    end
  end
end

shared_examples 'show action' do
  describe 'GET #show' do
    let(:params) { { id: object.id } }
    let(:request_example) { get :show, params: params }

    context 'with valid params' do
      before { request_example }

      let(:params) { valid_params }

      it { is_expected.to render_template(:show) }
    end

    context 'with invalid params' do
      before { request_example }

      let(:params) { invalid_params }

      it { is_expected.to redirect_to(redirect_path) }
    end
  end
end

shared_examples 'edit action' do
  describe 'GET #edit' do
    let(:request_example) { get :edit, params: params }

    it { expect(request_example).to render_template(:edit) }

    it_behaves_like 'requires an authenticated user'
  end
end

shared_examples 'update action' do
  describe 'PATCH #update' do
    let(:params) { {} }
    let(:request_example) { patch :update, params: params }

    context 'with valid params' do
      before { request_example }

      let(:params) { valid_params }

      it { expect(object.reload.send(attribute)).to eq(new_value) }
      it { is_expected.to redirect_to(redirect_path) }
    end

    context 'with invalid params' do
      before { request_example }

      let(:params) { invalid_params }

      it { is_expected.to render_template(:edit) }
    end
  end
end

shared_examples 'destroy action' do
  describe 'DELETE #destroy' do
    let(:request_example) { delete :destroy, params: params, xhr: true }
    let(:destroy_template) { defined?(optional_template) ? optional_template : 'shared/destroy' }

    it { expect(request_example).to render_template(destroy_template) }

    it_behaves_like 'requires an authenticated user'
  end
end

shared_examples 'html destroy action' do
  describe 'DELETE #destroy' do
    let(:request_example) { delete :destroy, params: params }

    it { expect(request_example).to redirect_to(redirect_path) }

    it_behaves_like 'requires an authenticated user'
  end
end
