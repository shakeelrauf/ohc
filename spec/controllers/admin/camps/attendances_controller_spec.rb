# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Camps::AttendancesController, type: :controller do
  include_context 'with cometchat calls'

  let(:admin) { create(:admin) }

  let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
  let(:season) { create(:season, camp_location: camp_location) }
  let(:camp) { create(:camp, season: season) }
  let(:cabin) { create(:cabin, camp: camp) }

  let(:child) { create(:child, tenant: admin.tenant) }
  let(:attendance) { create(:attendance, user: child, camp: camp, cabin: cabin) }

  before { admin_login(admin) }

  describe 'GET #index with CSV format' do
    let(:example_request) { get :index, params: { camp_id: camp.id, format: :csv } }
    let!(:attendances) { create_list(:attendance, 3, camp: camp, cabin: cabin) }

    before do
      create_list(:attendance, 2)

      example_request
    end

    it { expect(response.body.lines.size - 1).to eq(attendances.size) }

    it 'contains the correct codes' do
      attendances.pluck(:code).each do |code|
        expect(response.body).to include(code)
      end
    end
  end

  it_behaves_like 'new action' do
    let(:params) { { camp_id: camp.id } }
  end

  it_behaves_like 'create action' do
    let(:user_id) { create(:child, tenant: admin.tenant).id }
    let(:valid_params) do
      {
        camp_id: camp.id,
        attendance: {
          user_id: user_id,
          cabin_id: cabin.id
        }
      }
    end
    let(:invalid_params) do
      {
        camp_id: camp.id,
        attendance: {
          user_id: user_id,
          cabin_id: nil
        }
      }
    end
    let(:redirect_path) { camp_cabin_path(camp, cabin) }
  end

  it_behaves_like 'edit action' do
    let(:params) { { camp_id: camp.id, id: attendance.id } }
  end

  it_behaves_like 'update action' do
    let(:camp) { create(:camp, season: season) }

    # Setup: Update should function
    let(:new_value) { create(:cabin, camp: attendance.camp).id }
    let(:valid_params) { { camp_id: camp.id, id: attendance.id, attendance: { cabin_id: new_value } } }
    let(:object) { attendance }
    let(:attribute) { :cabin_id }

    # Setup: Update should fail
    let(:invalid_params) { { camp_id: camp.id, id: attendance.id, attendance: { cabin_id: -1 } } }

    let(:redirect_path) { camp_cabin_path(camp, new_value) }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { camp_id: camp.id, id: attendance.id } }
    let(:redirect_path) { camp_cabin_path(camp, attendance.cabin) }
  end
end
