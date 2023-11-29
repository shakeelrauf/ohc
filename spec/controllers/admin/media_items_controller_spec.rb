# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MediaItemsController, type: :controller do
  let(:admin) { create(:admin) }
  let(:invalid_file) { fixture_file_upload('spec/fixtures/files/small.pdf', 'application/pdf') }

  before { admin_login(admin) }

  context 'when national' do
    let(:media_item) { create(:national_media_item, tenant: admin.tenant) }

    it_behaves_like 'index action' do
      before do
        create_list(:media_item, 2)
      end
    end

    it_behaves_like 'new action'

    it_behaves_like 'create action' do
      let(:valid_params) { { media_item: attributes_for(:media_item) } }
      let(:invalid_params) { { media_item: { attachment: invalid_file } } }
      let(:redirect_path) { media_items_path }
    end

    it_behaves_like 'edit action' do
      let(:params) { { id: media_item.id } }
    end

    it_behaves_like 'update action' do
      let(:new_value) { false }
      let(:valid_params) { { id: media_item.id, media_item: { active: new_value } } }
      let(:invalid_params) { { id: media_item.id, media_item: { attachment: invalid_file } } }
      let(:object) { media_item }
      let(:attribute) { :active }
      let(:redirect_path) { media_items_path }
    end

    it_behaves_like 'html destroy action' do
      let(:params) { { id: media_item.id } }
      let(:redirect_path) { media_items_path }
    end
  end

  context 'when camp' do
    let(:camp_location) { create(:camp_location, tenant: admin.tenant) }
    let(:season) { create(:season, camp_location: camp_location) }
    let(:camp) { create(:camp, season: season) }
    let(:media_item) { create(:camp_media_item, tenant: admin.tenant, camp: camp) }

    it_behaves_like 'index action' do
      before do
        create_list(:media_item, 2, tenant: admin.tenant, camp: camp)
      end

      let(:params) { { camp_id: camp.id } }
    end

    it_behaves_like 'new action' do
      let(:params) { { camp_id: camp.id } }
    end

    it_behaves_like 'create action' do
      let(:valid_params) { { camp_id: camp.id, media_item: attributes_for(:media_item, camp: camp) } }
      let(:invalid_params) { { camp_id: camp.id, media_item: { attachment: invalid_file } } }
      let(:redirect_path) { camp_media_items_path(camp) }
    end

    it_behaves_like 'edit action' do
      let(:params) { { camp_id: camp.id, id: media_item.id } }
    end

    it_behaves_like 'update action' do
      let(:new_value) { false }
      let(:valid_params) { { camp_id: camp.id, id: media_item.id, media_item: { active: new_value } } }
      let(:invalid_params) { { camp_id: camp.id, id: media_item.id, media_item: { attachment: invalid_file } } }
      let(:object) { media_item }
      let(:attribute) { :active }
      let(:redirect_path) { camp_media_items_path(camp) }
    end

    it_behaves_like 'html destroy action' do
      let(:params) { { camp_id: camp.id, id: media_item.id } }
      let(:redirect_path) { camp_media_items_path(camp) }
    end
  end
end
