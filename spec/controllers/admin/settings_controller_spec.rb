# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SettingsController, type: :controller do
  let(:admin) { create(:tenant_admin) }

  before do
    admin_login(admin)
  end

  let(:contact_email_setting) { Setting.find_by(name: 'Contact Email') }

  # Settings are preloaded via the seedfile
  it_behaves_like 'index action'

  it_behaves_like 'edit action' do
    let(:params) { { id: contact_email_setting.id } }
  end

  it_behaves_like 'update action' do
    let(:new_value) { 'new.email@example.com' }
    let(:valid_params) { { id: contact_email_setting.id, setting: { value: new_value } } }
    let(:invalid_params) { { id: contact_email_setting.id, setting: { value: '' } } }
    let(:object) { contact_email_setting }
    let(:attribute) { :value }
    let(:redirect_path) { settings_path }
  end
end
