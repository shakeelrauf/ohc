# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ThemesController, type: :controller do
  let(:admin) { create(:admin) }
  let(:theme) { create(:theme, tenant: admin.tenant) }

  before { admin_login(admin) }

  it_behaves_like 'index action' do
    before do
      create_list(:theme, 2)
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    let(:valid_params) { { theme: attributes_for(:theme) } }
    let(:invalid_params) { { theme: { name: '' } } }
    let(:redirect_path) { themes_path }
  end

  context 'when camp admin' do
    let(:camp_admin) { create(:admin, :camp_admin, camp_location: create(:camp_location)) }
    let(:camp_location) { create(:camp_location) }
    let(:request_example) { post :create, params: { theme: attributes_for(:theme).merge(camp_location_id: camp_location.id) } }

    before do
      admin_login(camp_admin)
      request_example
    end

    it 'cannot set camp_location_id' do
      expect(assigns(:theme).camp_location_id).not_to eq(camp_location.id)
    end

    it 'is set to the users camp_location_id' do
      expect(assigns(:theme).camp_location_id).to eq(camp_admin.camp_location_id)
    end
  end

  context 'when super_admin' do
    let(:camp_admin) { create(:admin, :camp_admin, camp_location: create(:camp_location)) }
    let(:camp_location) { create(:camp_location) }
    let(:request_example) { post :create, params: { theme: attributes_for(:theme).merge(camp_location_id: camp_location.id) } }

    before do
      admin_login
      request_example
    end

    it 'can set camp_location_id' do
      expect(assigns(:theme).camp_location_id).to eq(camp_location.id)
    end

    it 'is not set to the users camp_location_id' do
      expect(assigns(:theme).camp_location_id).not_to eq(camp_admin.camp_location_id)
    end
  end

  it_behaves_like 'show action' do
    before do
      create_list(:score, 5, scope: theme)
    end

    let(:valid_params) { { id: theme.id } }
    let(:invalid_params) { { id: -1 } }
    let(:redirect_path) { root_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: theme.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New theme' }
    let(:valid_params) { { id: theme.id, theme: { name: new_value } } }
    let(:invalid_params) { { id: theme.id, theme: { name: '' } } }
    let(:object) { theme }
    let(:attribute) { :name }
    let(:redirect_path) { themes_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: theme.id } }
    let(:redirect_path) { themes_path }
  end
end
