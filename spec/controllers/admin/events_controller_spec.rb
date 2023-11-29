# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::EventsController, type: :controller do
  include_context 'with cometchat calls'

  let(:admin) { create(:admin) }

  before { admin_login(admin) }

  context 'when national' do
    it_behaves_like 'event crud actions' do
      let(:factory_name) { :national_event }
      let(:event_type) { 'national' }
      let(:event) { create(factory_name, tenant: admin.tenant, admin: admin) }
      let(:additional_create_attributes) { {} }
    end
  end

  context 'when camp' do
    it_behaves_like 'event crud actions' do
      let(:factory_name) { :camp_event }
      let(:event_type) { 'camp' }
      let(:event) { create(factory_name, :with_targets, tenant: admin.tenant, admin: admin) }
      let(:additional_create_attributes) { { camp_ids: event.camp_ids } }
    end
  end

  context 'when cabin' do
    it_behaves_like 'event crud actions' do
      let(:factory_name) { :cabin_event }
      let(:event_type) { 'cabin' }
      let(:event) { create(factory_name, :with_targets, tenant: admin.tenant, admin: admin) }
      let(:additional_create_attributes) { { cabin_ids: event.cabin_ids } }
    end
  end
end
