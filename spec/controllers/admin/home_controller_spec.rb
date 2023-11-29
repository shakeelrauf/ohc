# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::HomeController, type: :controller do
  describe 'GET #index' do
    it 'redirect when not logged in' do
      get :index

      expect(response).to redirect_to(login_path)
    end

    context 'when super admin' do
      let(:admin) { create(:admin) }

      before do
        admin_login(admin)
        get :index
      end

      it { expect(response).to redirect_to(camp_locations_path) }
      it { expect(admin.reload.last_active_at).not_to eq(nil) }
    end

    context 'when camp admin' do
      let(:camp_admin) { create(:admin, :camp_admin, camp_location: create(:camp_location)) }

      before do
        admin_login(camp_admin)
        get :index
      end

      it { expect(response).to redirect_to(camp_location_path(camp_admin.camp_location)) }
    end

    context 'when cabin admin' do
      before do
        admin_login(create(:admin, :cabin_admin, camp_location: create(:camp_location)))
        get :index
      end

      it { expect(response).to redirect_to(events_path(event_type: 'cabin')) }
    end
  end
end
