# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CampLocationsController, type: :controller do
  let(:admin) { create(:admin) }
  let(:camp_location) { create(:camp_location, tenant: admin.tenant) }

  before { admin_login(admin) }

  context 'when user is a super_admin' do
    it_behaves_like 'index action' do
      before do
        create_list(:camp_location, 2, tenant: admin.tenant)
      end
    end

    it_behaves_like 'new action'

    it_behaves_like 'create action' do
      let(:valid_params) { { camp_location: attributes_for(:camp_location) } }
      let(:invalid_params) { { camp_location: { name: '' } } }
      let(:redirect_path) { camp_location_path(assigns(:camp_location)) }
    end

    it_behaves_like 'edit action' do
      let(:params) { { id: camp_location.id } }
    end

    it_behaves_like 'update action' do
      let(:new_value) { 'New Name' }
      let(:valid_params) { { id: camp_location.id, camp_location: { name: new_value } } }
      let(:invalid_params) { { id: camp_location.id, camp_location: { name: '' } } }
      let(:object) { camp_location }
      let(:attribute) { :name }
      let(:redirect_path) { camp_locations_path }
    end

    it_behaves_like 'html destroy action' do
      let(:params) { { id: camp_location.id } }
      let(:redirect_path) { camp_locations_path }
    end
  end
end
