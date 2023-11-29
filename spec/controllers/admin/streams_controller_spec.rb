# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::StreamsController, type: :controller do
  let(:admin) { create(:admin, :tenant_admin) }
  let(:stream) { create(:stream) }

  before { admin_login(admin) }

  it_behaves_like 'index action' do
    before do
      create_list(:stream, 2)
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    before do
      WebMock.stub_request(:post, 'https://medialive.eu-west-1.amazonaws.com/prod/inputs')
             .to_return(status: 200, body: { input: { id: stream.aws_input_id } }.to_json.to_s, headers: {})

      WebMock.stub_request(:post, 'https://medialive.eu-west-1.amazonaws.com/prod/channels')
             .to_return(status: 200, body: { channel: { id: stream.aws_channel_id, status: 'IDLE' } }.to_json.to_s, headers: {})
    end

    let(:valid_params) { { stream: attributes_for(:stream) } }
    let(:invalid_params) { { stream: { name: '' } } }
    let(:redirect_path) { streams_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: stream.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New stream' }
    let(:valid_params) { { id: stream.id, stream: { name: new_value } } }
    let(:invalid_params) { { id: stream.id, stream: { name: '' } } }
    let(:object) { stream }
    let(:attribute) { :name }
    let(:redirect_path) { streams_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: stream.id } }
    let(:redirect_path) { streams_path }
  end
end
