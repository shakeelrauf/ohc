# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Admin::GroupsController, type: :request do
  include_context 'with cometchat calls'

  let(:camp) { create(:camp) }
  let!(:cabin) { create(:cabin, camp: camp, chat_guid: 'valid_cabin_guid') }
  let(:group_guid) { cabin.chat_guid }

  let!(:attendance) { create(:attendance, user: user, camp: camp) }

  describe 'Joining a new chat group' do
    let(:headers) { auth_headers(user) }
    let(:example_request) do
      post '/api/v2/admin/groups.json', params: jsonapi_packet('groups', guid: group_guid), headers: headers, as: :json
    end

    before { example_request }

    context 'given they are an admin user' do
      let(:user_chat_uid) { user_uid_not_in_group }
      let(:user) { create(:admin, chat_uid: user_chat_uid) }

      context 'and already a member of the group' do
        let(:user_chat_uid) { user_uid_already_in_group }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'and NOT a member of the group' do
        it { expect(response).to have_http_status(:ok) }
      end

      context 'and they try to join a live event' do
        let(:event) { create(:event, :with_chat_guid) }
        let(:group_guid) { event.chat_guid }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'and they try to join a cabin that doesnt belong to one of their camps' do
        let(:different_camp) { create(:camp, :with_cabins) }
        let(:group_guid) { different_camp.cabins.first.chat_guid }

        it { expect(response).to have_http_status(:forbidden) }
      end

      context 'and they use an invalid group guid' do
        let(:group_guid) { 'invalid_cabin_guid' }

        it { expect(response).to have_http_status(:not_found) }
      end
    end

    context 'given they are NOT an admin' do
      let(:user) { create(:child) }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end
