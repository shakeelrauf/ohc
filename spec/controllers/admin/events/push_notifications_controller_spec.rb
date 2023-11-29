# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Events::PushNotificationsController, type: :controller do
  let(:admin) { create(:super_admin) }
  let(:event) { create(:national_event, tenant: admin.tenant) }

  before { admin_login(admin) }

  describe 'GET #new' do
    let(:params) { { event_id: event.id, event_type: 'national' } }
    let(:request_example) { get :new, params: params }

    it { expect(request_example).to render_template(:new) }
    it { expect(request_example).to have_http_status(:ok) }
  end

  describe 'POST #create' do
    let(:default_params) { { event_id: event.id, event_type: 'national' } }
    let(:request_example) { post :create, params: params }

    context 'when valid params' do
      let(:params) { default_params.merge(event_push_notification: { title: 'Title', body: 'Body' }) }

      it { expect(request_example).to redirect_to(events_path(event_type: 'national', past: event.finished?)) }
    end

    context 'when invalid params' do
      let(:params) { default_params.merge(event_push_notification: { title: 'Title' }) }

      it { expect(request_example).to render_template(:new) }
    end
  end
end
