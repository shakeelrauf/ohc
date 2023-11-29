# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::MergesController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    admin_login(admin)
  end

  it_behaves_like 'new action' do
    before do
      create_list(:child, 2)
    end
  end

  describe 'POST #create' do
    let(:source) { create(:child, tenant: admin.tenant) }
    let(:destination) { create(:child, tenant: admin.tenant) }

    let(:params) { { source_id: source.id, destination_id: destination.id } }
    let(:request_example) { post :create, params: params }

    before do
      request_example
    end

    context 'with valid params' do
      it { is_expected.to redirect_to(user_attendances_path(destination)) }
    end

    context 'with invalid params' do
      let(:params) { {} }

      it { is_expected.to render_template(:new) }
    end
  end
end
