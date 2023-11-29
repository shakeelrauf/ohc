# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CampsController, type: :controller do
  include_context 'with cometchat calls'

  let(:admin) { create(:admin) }
  let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
  let(:season) { create(:season, camp_location: camp_location) }
  let(:camp) { create(:camp, season: season) }

  let(:default_params) { { season_id: camp.season_id } }

  before { admin_login(admin) }

  it_behaves_like 'new action' do
    let(:params) { default_params }
  end

  it_behaves_like 'create action' do
    let(:valid_params) { default_params.merge(camp: attributes_for(:camp)) }
    let(:invalid_params) { default_params.merge(camp: { name: '' }) }
    let(:redirect_path) { camp_location_path(assigns(:camp).camp_location) }
  end

  it_behaves_like 'edit action' do
    let(:params) { default_params.merge(id: camp.id) }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Name' }
    let(:valid_params) { default_params.merge(id: camp.id, camp: { name: new_value }) }
    let(:invalid_params) { default_params.merge(id: camp.id, camp: { name: '' }) }
    let(:object) { camp }
    let(:attribute) { :name }
    let(:redirect_path) { camp_location_path(assigns(:camp).camp_location) }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { default_params.merge(id: camp.id) }
    let(:redirect_path) { camp_location_path(assigns(:camp).camp_location) }
  end
end
