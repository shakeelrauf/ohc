# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Users::AttendancesController, type: :controller do
  let(:admin) { create(:admin) }
  let(:child) { create(:child, :preregistration, tenant: admin.tenant) }
  let(:attendance) { create(:attendance, user: child) }

  before do
    admin_login(admin)
  end

  it_behaves_like 'index action' do
    before do
      create_list(:attendance, 2, user: child)
    end

    let(:params) { { user_id: child.id } }
  end

  it_behaves_like 'html destroy action' do
    let(:params) { { user_id: child.id, id: attendance.id } }
    let(:redirect_path) { user_attendances_path(child) }
  end
end
