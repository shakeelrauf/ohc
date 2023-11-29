# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ColorThemesController, type: :controller do
  let(:admin) { create(:tenant_admin) }
  let(:color_theme) { create(:color_theme) }

  before { admin_login(admin) }

  it_behaves_like 'index action' do
    before do
      create_list(:color_theme, 2)
    end
  end

  it_behaves_like 'new action'

  it_behaves_like 'create action' do
    let(:valid_params) { { color_theme: attributes_for(:color_theme) } }
    let(:invalid_params) { { color_theme: { name: '' } } }
    let(:redirect_path) { color_themes_path }
  end

  it_behaves_like 'edit action' do
    let(:params) { { id: color_theme.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'New Default Video' }
    let(:valid_params) { { id: color_theme.id, color_theme: { name: new_value } } }
    let(:invalid_params) { { id: color_theme.id, color_theme: { name: '' } } }
    let(:object) { color_theme }
    let(:attribute) { :name }
    let(:redirect_path) { color_themes_path }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { id: color_theme.id } }
    let(:redirect_path) { color_themes_path }
  end
end
