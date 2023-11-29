# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SeasonsController, type: :controller do
  let(:admin) { create(:admin) }

  let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
  let(:season) { create(:season, camp_location: camp_location) }

  let(:default_params) { { camp_location_id: season.camp_location_id } }

  before { admin_login(admin) }

  it_behaves_like 'new action' do
    let(:params) { default_params }
  end

  it_behaves_like 'create action' do
    let(:valid_params) { default_params.merge(season: attributes_for(:season)) }
    let(:invalid_params) { default_params.merge(season: { name: '' }) }
    let(:redirect_path) { camp_location_path(season.camp_location) }
  end

  it_behaves_like 'edit action' do
    let(:params) { default_params.merge(id: season.id) }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Name' }
    let(:valid_params) { default_params.merge(id: season.id, season: { name: new_value }) }
    let(:invalid_params) { default_params.merge(id: season.id, season: { name: '' }) }
    let(:object) { season }
    let(:attribute) { :name }
    let(:redirect_path) { camp_location_path(season.camp_location) }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { default_params.merge(id: season.id) }
    let(:redirect_path) { camp_location_path(season.camp_location) }
  end
end
