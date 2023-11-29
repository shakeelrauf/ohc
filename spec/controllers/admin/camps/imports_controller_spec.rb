# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Camps::ImportsController, type: :controller do
  let(:admin) { create(:admin) }

  let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
  let(:season) { create(:season, camp_location: camp_location) }
  let(:camp) { create(:camp, season: season) }

  before do
    admin_login(admin)
  end

  it_behaves_like 'new action' do
    let(:params) { { camp_id: camp.id } }
  end

  describe 'POST #create' do
    let(:valid_csv) { fixture_file('Test Sheet - Camp.csv', 'text/csv') }
    let(:params) { { camp_id: camp.id, import: { csv_file: valid_csv } } }
    let(:example_request) { post :create, params: params }

    before do
      example_request
    end

    it { expect(response).to redirect_to(camp_import_path(camp, assigns(:import))) }

    context 'with queueing returning invalid' do
      let(:valid_csv) { fixture_file('fixture.mp4', 'video/mp4') }
      let(:import) { build(:camp_import, scope: camp, csv_file: valid_csv) }

      it { expect(response).to render_template(:new) }
    end
  end
end
