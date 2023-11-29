# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CabinsController, type: :controller do
  include_context 'with cometchat calls'

  let(:admin) { create(:admin) }

  let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
  let(:season) { create(:season, camp_location: camp_location) }
  let(:camp) { create(:camp, season: season) }
  let(:cabin) { create(:cabin, camp: camp) }

  let(:default_params) { { camp_id: camp.id } }

  before { admin_login(admin) }

  it_behaves_like 'new action' do
    let(:params) { default_params }
  end

  it_behaves_like 'create action' do
    let(:valid_params) { default_params.merge(cabin: attributes_for(:cabin)) }
    let(:invalid_params) { default_params.merge(cabin: { name: '' }) }
    let(:redirect_path) { camp_location_path(assigns(:cabin).camp.camp_location) }
  end

  it_behaves_like 'show action' do
    let(:valid_params) { default_params.merge(id: cabin.id) }
    let(:invalid_params) { default_params.merge(id: -1) }
    let(:redirect_path) { root_path }
  end

  describe 'GET #show with search params' do
    let(:params) { { camp_id: cabin.camp_id, id: cabin.id, search_term: search_term } }
    let(:example_request) { get :show, params: params }

    let(:first_name) { 'Targetted' }
    let(:last_name) { 'Camperson' }

    let(:target_user) { create(:child, first_name: first_name, last_name: last_name) }
    let!(:target_attendance) { create(:attendance, user: target_user, camp: cabin.camp, cabin: cabin) }
    let!(:admin_attendance) { create(:attendance, :by_admin, camp: cabin.camp, cabin: cabin) }

    before do
      create_list(:attendance, 3, camp: cabin.camp, cabin: cabin)
      example_request
    end

    context 'when first name is used' do
      let(:search_term) { first_name }

      it { expect(assigns(:child_attendances).to_a).to eq([target_attendance]) }
    end

    context 'when last name is used' do
      let(:search_term) { last_name }

      it { expect(assigns(:child_attendances).to_a).to eq([target_attendance]) }
    end

    context 'when full name is used' do
      let(:search_term) { "#{first_name} #{last_name}" }

      it { expect(assigns(:child_attendances).to_a).to eq([target_attendance]) }
    end

    context 'when code is used' do
      let(:search_term) { target_attendance.code }

      it { expect(assigns(:child_attendances).to_a).to eq([target_attendance]) }
    end

    context 'when an unrecognised search term is used' do
      let(:search_term) { 'UNRECOGNISED' }

      it { expect(assigns(:child_attendances).size).to be(0) }
    end

    context 'when an admin last name is searched' do
      let(:search_term) { admin_attendance.user.last_name }

      it { expect(assigns(:admin_attendances).to_a).to eq([admin_attendance]) }
    end
  end

  it_behaves_like 'edit action' do
    let(:params) { default_params.merge(id: cabin.id) }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Name' }
    let(:valid_params) { default_params.merge(id: cabin.id, cabin: { name: new_value }) }
    let(:invalid_params) { default_params.merge(id: cabin.id, cabin: { name: '' }) }
    let(:object) { cabin }
    let(:attribute) { :name }
    let(:redirect_path) { camp_location_path(assigns(:cabin).camp.camp_location) }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { default_params.merge(id: cabin.id) }
    let(:redirect_path) { camp_location_path(assigns(:cabin).camp.camp_location) }
  end
end
