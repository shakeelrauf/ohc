# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::EventsController, type: :request do
  include_context 'with cometchat calls'

  let(:camp_location) { create(:camp_location) }
  let(:season) { create(:season, :with_camps_and_cabins, camp_location: camp_location) }
  let(:camp_ids) { season.camp_ids }

  let(:admin) { create(:admin, tenant: camp_location.tenant) }
  let(:camp_admin) { create(:camp_admin, tenant: camp_location.tenant, camp_location: camp_location) }
  let(:cabin_admin) { create(:cabin_admin, tenant: camp_location.tenant, camp_location: camp_location) }

  let!(:stream) { create(:stream, :with_stop, :with_start) }

  let(:headers) { auth_headers(admin) }

  describe 'Creating an event' do
    context 'Given that a user wants to create a national event' do
      let(:example_request) do
        post '/api/v2/admin/events', params: jsonapi_packet('event', params), headers: headers, as: :json
      end
      let(:params) do
        {
          active: true,
          name: 'event name',
          description: 'event description',
          event_type: 'national',
          starts_at: 1.hour.ago.round.iso8601(3),
          ends_at: 1.hour.from_now.round.iso8601(3)
        }
      end

      context 'And that user is a super user' do
        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expected_attributes = {
              'name' => params['name'],
              'description' => params['description'],
              'kind' => 'National',
              'endsAt' => params['endsAt'],
              'startsAt' => params['startsAt']
            }

            expect(response).to have_http_status(:created)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to create a camp event' do
      let(:event) do
        {
          active: true,
          name: 'camp event',
          description: 'event description',
          event_type: 'camp',
          starts_at: 1.hour.ago.round.iso8601(3),
          ends_at: 1.hour.from_now.round.iso8601(3),
          camp_ids: camp_ids,
          relationships: create_relationships(targets: [target])
        }
      end

      let(:target) { { id: 1, type: :target } }
      let(:included) { [target] }

      let(:example_request) do
        post '/api/v2/admin/events?include=targets', params: jsonapi_packet_with_include('event', event.except(:relationships), included), headers: headers, as: :json
      end

      context 'And that user is a super user' do
        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expected_attributes = {
              'name' => event[:name],
              'description' => event[:description],
              'kind' => 'Camp',
              'endsAt' => event[:ends_at],
              'startsAt' => event[:starts_at]
            }

            expect(response).to have_http_status(:created)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct camps as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(camp_ids)
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expected_attributes = {
              'name' => event[:name],
              'description' => event[:description],
              'kind' => 'Camp',
              'endsAt' => event[:ends_at],
              'startsAt' => event[:starts_at]
            }

            expect(response).to have_http_status(:created)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct camps as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(camp_ids)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to create a cabin event' do
      let(:cabins) { season.camps.first.cabins }
      let(:cabin_ids) { cabins.map { |cabin| cabin['id'].to_i } }

      let(:event) do
        {
          active: true,
          name: 'cabin event',
          description: 'event description',
          event_type: 'cabin',
          starts_at: 1.hour.ago.round.iso8601(3),
          ends_at: 1.hour.from_now.round.iso8601(3),
          cabin_ids: cabin_ids,
          relationships: create_relationships(targets: [target])
        }
      end
      let(:target) { { id: 1, type: :target } }
      let(:included) { [target] }

      let(:example_request) do
        post '/api/v2/admin/events?include=targets', params: jsonapi_packet_with_include('event', event.except(:relationships), included), headers: headers, as: :json
      end

      context 'And that user is a super user' do
        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expected_attributes = {
              'name' => event[:name],
              'description' => event[:description],
              'kind' => 'Cabin',
              'endsAt' => event[:ends_at],
              'startsAt' => event[:starts_at]
            }

            expect(response).to have_http_status(:created)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct cabins as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(cabin_ids)
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expected_attributes = {
              'name' => event[:name],
              'description' => event[:description],
              'kind' => 'Cabin',
              'endsAt' => event[:ends_at],
              'startsAt' => event[:starts_at]
            }

            expect(response).to have_http_status(:created)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct cabins as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(cabin_ids)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }
        let!(:attendance) { create(:attendance, user: admin, camp: season.camps.first) }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expected_attributes = {
              'name' => event[:name],
              'description' => event[:description],
              'kind' => 'Cabin',
              'endsAt' => event[:ends_at],
              'startsAt' => event[:starts_at]
            }

            expect(response).to have_http_status(:created)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct cabins as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(cabin_ids)
          end
        end
      end
    end
  end

  describe 'Updating an event' do
    context 'Given that a user wants to update a national event' do
      let(:example_request) do
        patch "/api/v2/admin/events/#{event.id}", params: jsonapi_packet('event', params), headers: headers, as: :json
      end

      let(:event) { create(:national_event, tenant: camp_location.tenant) }
      let(:params) do
        {
          active: true,
          name: 'event name',
          description: 'event description',
          event_type: 'national',
          starts_at: 1.hour.ago.round.iso8601(3),
          ends_at: 1.hour.from_now.round.iso8601(3)
        }
      end

      context 'And that user is a super user' do
        context 'when they make a request to update the event' do
          before { example_request }

          it 'then responds with ok and the updated event' do
            expected_attributes = {
              'name' => params['name'],
              'description' => params['description'],
              'kind' => 'National',
              'endsAt' => params['endsAt'],
              'startsAt' => params['startsAt']
            }

            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']).to include(expected_attributes)
            expect(response_json['data']['attributes']['url']).not_to eq(nil)
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to update a camp event' do
      let(:event) { create(:camp_event, tenant: camp_location.tenant, camp_ids: camp_ids) }

      let(:new_season) { create(:season, :with_camps) }
      let(:new_camps_ids) { new_season.camps.map { |camp| camp['id'].to_i } }
      let(:updated_event) do
        {
          active: true,
          name: 'camp event',
          description: 'event description',
          event_type: 'camp',
          starts_at: 1.hour.ago.round.iso8601(3),
          ends_at: 1.hour.from_now.round.iso8601(3),
          camp_ids: new_camps_ids,
          relationships: create_relationships(targets: [target])
        }
      end

      let(:target) { { id: 1, type: :target } }
      let(:included) { [target] }

      let(:example_request) do
        patch "/api/v2/admin/events/#{event.id}?include=targets", params: jsonapi_packet_with_include('event', updated_event.except(:relationships), included), headers: headers, as: :json
      end

      context 'And that user is a super user' do
        context 'when they make a request to update the event' do
          before { example_request }

          it 'then responds with ok and the updated event' do
            expected_attributes = {
              'name' => updated_event[:name],
              'description' => updated_event[:description],
              'kind' => 'Camp',
              'endsAt' => updated_event[:ends_at],
              'startsAt' => updated_event[:starts_at]
            }

            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct camps as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(new_camps_ids)
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to update the event' do
          before { example_request }

          it 'then responds with ok and the updated event' do
            expected_attributes = {
              'name' => updated_event[:name],
              'description' => updated_event[:description],
              'kind' => 'Camp',
              'endsAt' => updated_event[:ends_at],
              'startsAt' => updated_event[:starts_at]
            }

            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct camps as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(new_camps_ids)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to update a cabin event' do
      let(:cabin_ids) { season.camps.first.cabins.map { |cabin| cabin['id'].to_i } }
      let(:event) { create(:cabin_event, tenant: camp_location.tenant, cabin_ids: cabin_ids) }

      let(:new_season) { create(:season, :with_camps_and_cabins) }
      let(:new_cabins_ids) { new_season.camps.first.cabins.map { |cabin| cabin['id'].to_i } }
      let(:updated_event) do
        {
          active: true,
          name: 'cabin event',
          description: 'event description',
          event_type: 'cabin',
          starts_at: 1.hour.ago.round.iso8601(3),
          ends_at: 1.hour.from_now.round.iso8601(3),
          cabin_ids: new_cabins_ids,
          relationships: create_relationships(targets: [target])
        }
      end

      let(:target) { { id: 1, type: :target } }
      let(:included) { [target] }

      let(:example_request) do
        patch "/api/v2/admin/events/#{event.id}?include=targets", params: jsonapi_packet_with_include('event', updated_event.except(:relationships), included), headers: headers, as: :json
      end

      context 'And that user is a super user' do
        context 'when they make a request to update the event' do
          before { example_request }

          it 'then responds with ok and the updated event' do
            expected_attributes = {
              'name' => updated_event[:name],
              'description' => updated_event[:description],
              'kind' => 'Cabin',
              'endsAt' => updated_event[:ends_at],
              'startsAt' => updated_event[:starts_at]
            }

            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct cabins as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(new_cabins_ids)
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to update the event' do
          before { example_request }

          it 'then responds with ok and the updated event' do
            expected_attributes = {
              'name' => updated_event[:name],
              'description' => updated_event[:description],
              'kind' => 'Cabin',
              'endsAt' => updated_event[:ends_at],
              'startsAt' => updated_event[:starts_at]
            }

            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct cabins as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(new_cabins_ids)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }
        let(:attendance_camp) { season.camps.first }
        let(:attendance_cabin) { attendance_camp.cabins.first }
        let!(:attendance) { create(:attendance, user: admin, camp: attendance_camp, cabin: attendance_cabin) }

        context 'when they make a request to update the event' do
          before { example_request }

          it 'then responds with ok and the updated event' do
            expected_attributes = {
              'name' => updated_event[:name],
              'description' => updated_event[:description],
              'kind' => 'Cabin',
              'endsAt' => updated_event[:ends_at],
              'startsAt' => updated_event[:starts_at]
            }

            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']).to include(expected_attributes)
          end

          it 'and has the correct cabins as the targets' do
            expect(response_json['included'].map { |target| target['attributes']['targetId'].to_i }).to eq(new_cabins_ids)
          end
        end
      end
    end
  end

  describe 'Starting an event' do
    let(:params) { { action: 'start' } }
    let(:example_request) do
      patch "/api/v2/admin/events/#{event.id}", params: jsonapi_packet('event', params), headers: headers, as: :json
    end

    context 'given that a user wants to start a national event' do
      let(:event) { create(:national_event, tenant: camp_location.tenant) }

      context 'And that user is a super user' do
        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('started')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'given that a user wants to start a camp event' do
      let(:event) { create(:camp_event, tenant: camp_location.tenant, camp_ids: camp_ids) }

      context 'And that user is a super user' do
        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('started')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('started')
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to start a cabin event' do
      let(:cabins) { season.camps.first.cabins }
      let(:cabin_ids) { cabins.map { |cabin| cabin['id'].to_i } }
      let(:event) { create(:cabin_event, tenant: camp_location.tenant, cabin_ids: cabin_ids) }

      context 'And that user is a super user' do
        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('started')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('started')
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }
        let!(:attendance) { create(:attendance, user: admin, camp: season.camps.first) }

        context 'when they make a request to create the event' do
          before { example_request }

          context 'when they make a request to create the event' do
            before { example_request }

            it 'then responds with created and the new event' do
              expect(response).to have_http_status(:ok)
              expect(response_json['data']['attributes']['status']).to eq('started')
            end
          end
        end
      end
    end
  end

  describe 'Stopping an event' do
    let(:params) { { action: 'stop' } }
    let(:example_request) do
      patch "/api/v2/admin/events/#{event.id}", params: jsonapi_packet('event', params), headers: headers, as: :json
    end

    context 'given that a user wants to stop a national event' do
      let(:event) { create(:national_event, :with_started, tenant: camp_location.tenant) }

      context 'And that user is a super user' do
        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('finished')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to start the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'given that a user wants to stop a camp event' do
      let(:event) { create(:camp_event, :with_started, tenant: camp_location.tenant, camp_ids: camp_ids) }

      context 'And that user is a super user' do
        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('finished')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('finished')
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to stop a cabin event' do
      let(:cabins) { season.camps.first.cabins }
      let(:cabin_ids) { cabins.map { |cabin| cabin['id'].to_i } }
      let(:event) { create(:cabin_event, :with_started, tenant: camp_location.tenant, cabin_ids: cabin_ids) }

      context 'And that user is a super user' do
        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('finished')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('finished')
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }
        let!(:attendance) { create(:attendance, user: admin, camp: season.camps.first) }

        context 'when they make a request to stop the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('finished')
          end
        end
      end
    end
  end

  describe 'Opening an event' do
    let(:params) { { action: 'open' } }
    let(:example_request) do
      patch "/api/v2/admin/events/#{event.id}", params: jsonapi_packet('event', params), headers: headers, as: :json
    end

    context 'given that a user wants to open a national event' do
      let(:event) { create(:national_event, :with_started, tenant: camp_location.tenant) }

      context 'And that user is a super user' do
        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('open')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'given that a user wants to open a camp event' do
      let(:event) { create(:camp_event, tenant: camp_location.tenant, camp_ids: camp_ids) }

      context 'And that user is a super user' do
        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('open')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with created and the new event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('open')
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with forbidden' do
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
    end

    context 'Given that a user wants to open a cabin event' do
      let(:cabins) { season.camps.first.cabins }
      let(:cabin_ids) { cabins.map { |cabin| cabin['id'].to_i } }
      let(:event) { create(:cabin_event, tenant: camp_location.tenant, cabin_ids: cabin_ids) }

      context 'And that user is a super user' do
        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with ok and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('open')
          end
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        context 'when they make a request to create the event' do
          before { example_request }

          it 'then responds with created and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('open')
          end
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }
        let!(:attendance) { create(:attendance, user: admin, camp: season.camps.first) }

        context 'when they make a request to open the event' do
          before { example_request }

          it 'then responds with created and the event' do
            expect(response).to have_http_status(:ok)
            expect(response_json['data']['attributes']['status']).to eq('open')
          end
        end
      end
    end
  end

  describe 'Deleting an event' do
    let(:example_request) do
      delete "/api/v2/admin/events/#{event.id}", headers: headers, as: :json
    end

    context 'given that the user wants to delete an event that doesnt exist' do
      let(:event_id) { 1 }
      let(:example_request) do
        delete "/api/v2/admin/events/#{event_id}", headers: headers, as: :json
      end

      before { example_request }

      it 'then responds with not found' do
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'given that the event is not closed' do
      let(:event) { create(:national_event, :with_started, tenant: camp_location.tenant) }

      context 'when they make a request to delete the event' do
        before { example_request }

        it 'then responds with conflict' do
          expect(response).to have_http_status(:conflict)
        end
      end
    end

    context 'given that a user wants to delete a national event' do
      let(:event) { create(:national_event, tenant: camp_location.tenant) }

      context 'And that user is a super user' do
        before { example_request }

        it 'then responds with no content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'and has deleted the event' do
          expect(Event.count).to equal(0)
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        before { example_request }

        it 'then responds with forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        before { example_request }

        it 'then responds with forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'given that a user wants to delete a camp event' do
      let(:event) { create(:camp_event, tenant: camp_location.tenant, camp_ids: camp_ids) }

      before { example_request }

      context 'And that user is a super user' do
        it 'then responds with no content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'and has deleted the event' do
          expect(Event.count).to equal(0)
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        before { example_request }

        it 'then responds with no content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'and has deleted the event' do
          expect(Event.count).to equal(0)
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }

        before { example_request }

        it 'then responds with forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Given that a user wants to delete a cabin event' do
      let(:cabins) { season.camps.first.cabins }
      let(:cabin_ids) { cabins.map { |cabin| cabin['id'].to_i } }
      let(:event) { create(:cabin_event, tenant: camp_location.tenant, cabin_ids: cabin_ids) }

      context 'And that user is a super user' do
        before { example_request }

        it 'then responds with no content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'and has deleted the event' do
          expect(Event.count).to equal(0)
        end
      end

      context 'And that user is a camp admin user' do
        let(:admin) { camp_admin }

        before { example_request }

        it 'then responds with no content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'and has deleted the event' do
          expect(Event.count).to equal(0)
        end
      end

      context 'And that user is a cabin admin user' do
        let(:admin) { cabin_admin }
        let!(:attendance) { create(:attendance, user: admin, camp: season.camps.first) }

        before { example_request }

        it 'then responds with no content' do
          expect(response).to have_http_status(:no_content)
        end

        it 'and has deleted the event' do
          expect(Event.count).to equal(0)
        end
      end
    end
  end
end
