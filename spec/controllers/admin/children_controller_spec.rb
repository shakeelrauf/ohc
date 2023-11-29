# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ChildrenController, type: :controller do
  include_context 'with cometchat calls'

  let(:admin) { create(:admin) }
  let(:child) { create(:child, :preregistration, tenant: admin.tenant) }

  before do
    admin_login(admin)
  end

  it_behaves_like 'index action' do
    before do
      create_list(:child, 2, :preregistration, tenant: admin.tenant)
    end
  end

  describe 'GET #index with search params' do
    let(:params) { { q: search_params } }
    let(:example_request) { get :index, params: params }

    let(:first_name) { 'Targetted' }
    let(:last_name) { 'Camperson' }

    let!(:target_user) { create(:child, tenant: admin.tenant, first_name: first_name, last_name: last_name) }
    let(:target_attendance) { create(:attendance, user: target_user) }

    before do
      create_list(:child, 3)
      example_request
    end

    context 'when first name is used' do
      let(:search_params) { { first_name_cont: first_name } }

      it { expect(assigns(:children).to_a).to eq([target_user]) }
    end

    context 'when last name is used' do
      let(:search_params) { { last_name_cont: last_name } }

      it { expect(assigns(:children).to_a).to eq([target_user]) }
    end

    context 'when an unrecognised search term is used' do
      let(:search_params) { { first_name_cont: 'UNRECOGNISED' } }

      it { expect(assigns(:children).size).to be(0) }
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    let(:valid_params) { { user_child: attributes_for(:child, :preregistration) } }
    let(:invalid_params) { { user_child: { first_name: '' } } }
    let(:redirect_path) { children_path }
  end

  it_behaves_like 'create action' do
    let(:valid_params) { { user_child: attributes_for(:child, :preregistration) } }
    let(:invalid_params) { { user_child: attributes_for(:child, :preregistration, first_name: 'INVALID', last_name: 'USER') } }
    let(:redirect_path) { children_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: child.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Name' }
    let(:valid_params) { { id: child.id, user_child: { first_name: new_value } } }
    let(:invalid_params) { { id: child.id, user_child: { first_name: '' } } }
    let(:object) { child }
    let(:attribute) { :first_name }
    let(:redirect_path) { children_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: child.id } }
    let(:redirect_path) { children_path }
  end
end
