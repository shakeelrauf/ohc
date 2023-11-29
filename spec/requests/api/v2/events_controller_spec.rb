# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::EventsController, type: :request do
  let(:headers) { auth_headers(user) }

  describe '#index' do
    let(:camp_location) { create(:camp_location) }
    let(:season) { create(:season, camp_location: camp_location) }
    let(:camp) { create(:camp, season: season) }
    let(:cabin) { create(:cabin, camp: camp) }

    let(:national_event) { create(:national_event, tenant: camp_location.tenant) }
    let(:camp_event) { create(:camp_event, tenant: camp_location.tenant, camp_ids: [camp.id]) }
    let(:cabin_event) { create(:cabin_event, tenant: camp_location.tenant, cabin_ids: [cabin.id]) }

    let(:example_request) { get '/api/v2/events.json', headers: headers, as: :json }
    let(:response_ids) { response_json['data'].map { |event| event['id'].to_i } }

    before do |example|
      national_event
      camp_event
      cabin_event

      example_request unless example.metadata[:skip_request].present?
    end

    context 'when child' do
      let(:user) { create(:child, tenant: camp_location.tenant) }

      it 'includes national events' do
        expect(response_ids).to include(national_event.id)
      end

      it 'includes camp events i am a member of', skip_request: true do
        create(:attendance, user: user, camp: camp)
        example_request
        expect(response_ids).to include(camp_event.id)
      end

      it 'excludes camp events for camps i am not a member of' do
        expect(response_ids).not_to include(camp_event.id)
      end

      it 'includes cabin events i am a member of', skip_request: true do
        create(:attendance, user: user, camp: camp, cabin: cabin)
        example_request
        expect(response_ids).to include(cabin_event.id)
      end

      it 'excludes cabin events for cabins i am not a member of' do
        expect(response_ids).not_to include(cabin_event.id)
      end
    end

    context 'when super admin' do
      let(:user) { create(:admin, tenant: camp_location.tenant) }

      it 'includes national events' do
        expect(response_ids).to include(national_event.id)
      end

      it 'includes camp events' do
        expect(response_ids).to include(camp_event.id)
      end

      it 'includes cabin events' do
        expect(response_ids).to include(cabin_event.id)
      end
    end

    context 'when camp admin' do
      let(:user) { create(:admin, :camp_admin, tenant: camp_location.tenant, camp_location_id: camp_location.id) }

      it 'includes national events' do
        expect(response_ids).to include(national_event.id)
      end

      it 'includes camp events for my camp' do
        expect(response_ids).to include(camp_event.id)
      end

      it 'excludes camp events for other camps', skip_request: true do
        other_camp_event = create(:camp_event, :with_targets, tenant: camp_location.tenant)
        example_request
        expect(response_ids).not_to include(other_camp_event.id)
      end

      it 'includes cabin events for my camp' do
        expect(response_ids).to include(cabin_event.id)
      end

      it 'excludes cabin events for other camps', skip_request: true do
        other_cabin_event = create(:cabin_event, :with_targets, tenant: camp_location.tenant)
        example_request
        expect(response_ids).not_to include(other_cabin_event.id)
      end
    end

    context 'when cabin admin' do
      let(:user) do
        user = create(:admin, :cabin_admin, tenant: camp_location.tenant, camp_location: camp_location)
        create(:attendance, user: user, camp: camp, cabin: cabin)

        user
      end

      it 'includes national events' do
        expect(response_ids).to include(national_event.id)
      end

      it 'includes camp events for my camp' do
        expect(response_ids).to include(camp_event.id)
      end

      it 'excludes camp events for other camps', skip_request: true do
        other_camp_event = create(:camp_event, :with_targets, tenant: camp_location.tenant)
        example_request
        expect(response_ids).not_to include(other_camp_event.id)
      end

      it 'includes cabin events for my camp' do
        expect(response_ids).to include(cabin_event.id)
      end

      it 'excludes cabin events for other camps', skip_request: true do
        other_cabin_event = create(:cabin_event, :with_targets, tenant: camp_location.tenant)
        example_request
        expect(response_ids).not_to include(other_cabin_event.id)
      end
    end
  end

  describe 'Retrieve a single event' do
    let(:user) { create(:admin) }
    let(:event) { create(:national_event, tenant: user.tenant) }
    let(:example_request) { get "/api/v2/events/#{event.id}.json", headers: headers, as: :json }

    before do
      example_request
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response_json['data']['id'].to_i).to eq(event.id) }
  end
end
