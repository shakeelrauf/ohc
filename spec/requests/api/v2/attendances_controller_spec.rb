# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::AttendancesController, type: :request do
  let(:user) { create(:child, :preregistration) }
  let(:attendance) { create(:attendance, user: user) }
  let(:code) { attendance.code }
  let(:date_of_birth) { attendance.user.date_of_birth.to_s }

  describe 'Retrieving an attendance by code and date_of_birth' do
    let(:example_request) { get("/api/v2/attendances/#{code}", params: params, as: :json) }
    let(:params) { { dateOfBirth: date_of_birth } }

    before do
      example_request
    end

    context 'with a correct code and date_of_birth' do
      it { expect(response_json['data']['id']).to eq(code) }
      it { expect(response_json['data']['attributes']['tenantId']).to eq(attendance.user.tenant_id) }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when a registered child' do
      let(:user) { create(:child) }

      it { expect(response).to have_http_status(:forbidden) }
    end

    context 'when a registered admin' do
      let(:user) { create(:admin) }

      it { expect(response).to have_http_status(:forbidden) }
    end

    context 'with an incorrect code' do
      let(:code) { 'INVALID' }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'with an incorrect DoB' do
      let(:date_of_birth) { 20.years.ago.to_s }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'Attaching an attendance user to an authentication' do
    let(:auth_user) { create(:user) }
    let(:headers) { auth_headers(auth_user) }
    let(:example_request) { post('/api/v2/attendances', params: jsonapi_packet('attendance', params), headers: headers, as: :json) }
    let(:params) { { code: code, date_of_birth: date_of_birth } }

    before do
      example_request
    end

    context 'with a correct code and date_of_birth' do
      it { expect(response).to have_http_status(:ok) }
    end

    context 'with a correct code and date_of_birth but a child that already has an authentication' do
      let(:user) { create(:child) }

      it { expect(response).to have_http_status(:forbidden) }
    end

    context 'with an incorrect code' do
      let(:code) { 'INVALID' }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'with an incorrect DoB' do
      let(:date_of_birth) { 20.years.ago.to_s }

      it { expect(response).to have_http_status(:not_found) }
    end

    context 'with bad auth' do
      let(:headers) { {} }

      it { expect(response).to have_http_status(:forbidden) }
    end
  end
end
