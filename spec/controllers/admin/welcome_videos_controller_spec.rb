# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::WelcomeVideosController, type: :controller do
  let(:admin) { create(:admin) }
  let(:welcome_video) { create(:welcome_video, tenant: admin.tenant) }

  before { admin_login(admin) }

  it_behaves_like 'index action' do
    before do
      create_list(:welcome_video, 2)
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    let(:valid_params) { { welcome_video: attributes_for(:welcome_video) } }
    let(:invalid_params) { { welcome_video: { name: '' } } }
    let(:redirect_path) { welcome_videos_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: welcome_video.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Default Video' }
    let(:valid_params) { { id: welcome_video.id, welcome_video: { name: new_value } } }
    let(:invalid_params) { { id: welcome_video.id, welcome_video: { name: '' } } }
    let(:object) { welcome_video }
    let(:attribute) { :name }
    let(:redirect_path) { welcome_videos_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: welcome_video.id } }
    let(:redirect_path) { welcome_videos_path }
  end
end
