# frozen_string_literal: true

require 'rails_helper'

shared_examples 'event crud actions' do
  it_behaves_like 'index action' do
    before do
      create_list(factory_name, 2, :with_targets, admin: admin)
    end

    let(:params) { { event_type: event_type } }
  end

  it_behaves_like 'new action' do
    let(:params) { { event_type: event_type } }
  end

  it_behaves_like 'create action' do
    let(:valid_params) { { event_type: event_type, event: additional_create_attributes.merge(attributes_for(factory_name)) } }
    let(:invalid_params) { { event_type: event_type, event: { name: '' } } }
    let(:redirect_path) { events_path(event_type: event_type, past: false) }
  end

  it_behaves_like 'edit action' do
    let(:params) { { event_type: event_type, id: event.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New event' }
    let(:valid_params) { { event_type: event_type, id: event.id, event: { name: new_value } } }
    let(:invalid_params) { { event_type: event_type, id: event.id, event: { name: '' } } }
    let(:object) { event }
    let(:attribute) { :name }
    let(:redirect_path) { events_path(event_type: event_type, past: false) }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { event_type: event_type, id: event.id } }
    let(:redirect_path) { events_path(event_type: event_type, past: false) }
  end
end
