# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AdminsController, type: :controller do
  include_context 'with cometchat calls'

  let(:admin) { create(:admin) }

  before do
    admin_login(admin)
  end

  it_behaves_like 'index action' do
    before do
      create_list(:admin, 2, tenant: admin.tenant)
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    let(:role) { User::Admin.roles[:super_admin] }
    let(:valid_params) { { user_admin: attributes_for(:admin, role: role) } }
    let(:invalid_params) { { user_admin: { email: '', role: role } } }
    let(:redirect_path) { admins_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: admin.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'new.email@example.com' }
    let(:valid_params) { { id: admin.id, user_admin: { email: new_value } } }
    let(:invalid_params) { { id: admin.id, user_admin: { email: '' } } }
    let(:object) { admin }
    let(:attribute) { :email }
    let(:redirect_path) { admins_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: admin.id } }
    let(:redirect_path) { admins_path }
  end

  context 'when cabin_admin' do
    let(:admin) { create(:admin, :cabin_admin, camp_location: create(:camp_location)) }

    it_behaves_like 'update action' do
      let(:new_value) { 'new.email@example.com' }
      let(:valid_params) { { id: admin.id, user_admin: { email: new_value } } }
      let(:invalid_params) { { id: admin.id, user_admin: { email: '' } } }
      let(:object) { admin }
      let(:attribute) { :email }
      let(:redirect_path) { root_path }
    end
  end
end
