# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TenantsController, type: :controller do
  let(:admin) { create(:admin, :tenant_admin) }
  let(:tenant) { create(:tenant) }

  before { admin_login(admin) }

  it_behaves_like 'index action' do
    before do
      create_list(:tenant, 2)
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    let(:valid_params) { { tenant: attributes_for(:tenant, color_theme_id: create(:color_theme).id) } }
    let(:invalid_params) { { tenant: { name: '' } } }
    let(:redirect_path) { tenants_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: tenant.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Default Video' }
    let(:valid_params) { { id: tenant.id, tenant: { name: new_value } } }
    let(:invalid_params) { { id: tenant.id, tenant: { name: '' } } }
    let(:object) { tenant }
    let(:attribute) { :name }
    let(:redirect_path) { tenants_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: tenant.id } }
    let(:redirect_path) { tenants_path }
  end
end
