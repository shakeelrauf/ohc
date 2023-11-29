# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::Users::ReachableUsersController, type: :request do
  describe 'Retrieve the reachable users of the current user' do
    let(:season) { create(:season, :with_camps_and_cabins) }
    let(:headers) { auth_headers(user) }

    let(:example_request) { get '/api/v2/users/reachable_users.json', headers: headers, as: :json }

    context 'when cabin admin' do
      let(:user) do
        create(:cabin_admin, tenant: season.camp_location.tenant, camp_location: season.camp_location)
      end

      # A cabin user should be able to contact
      let(:reachable_users) do
        # A child (in one of their cabins)
        user_ids = create_list(:child, 2, tenant: user.tenant).pluck(:id)

        User.where(id: user_ids).order(:first_name, :last_name)
      end

      before do
        # As long as they attend the same cabin
        camp = season.camps.first
        cabin = camp.cabins.first

        # Create an attendance for each user we want reachable
        [*reachable_users, user].each do |reachable_user|
          create(:attendance, camp: camp, cabin: cabin, user: reachable_user)
        end

        # Create some extra users and attendances for other cabins,
        create_list(:attendance, 2, :by_child, camp: camp, cabin: camp.cabins.second)

        # Camps,
        create_list(:attendance, 2, :by_child, camp: season.camps.second)

        # and Tenants
        tenant = create(:user).tenant
        extra_camp = create(:camp, :with_cabins)
        extra_campers = [*create_list(:child, 2, tenant: tenant), *create_list(:user, 2, tenant: tenant)]

        extra_campers.each do |camper|
          create(:attendance, camp: extra_camp, user: camper)
        end

        example_request
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response_json['data'].map { |user_obj| user_obj['id'].to_i }).to eq(reachable_users.pluck(:id)) }
    end

    context 'when child camper' do
      let(:user) { create(:child, tenant: season.camp_location.tenant) }

      # A child camper should be able to contact Cabin Admins assigned to their Cabin
      let(:reachable_cabin_admins) do
        create_list(:cabin_admin, 2, tenant: user.tenant, camp_location: season.camp_location)
      end

      let(:reachable_users) do
        # Cabin Admins to their cabin
        user_ids = reachable_cabin_admins.pluck(:id)

        User.where(id: user_ids).order(:first_name, :last_name)
      end

      before do
        camp = season.camps.first
        cabin = camp.cabins.first

        # Create the attendance for the Child camper
        create(:attendance, user: user, camp: camp, cabin: cabin)

        # Create the attendance for the Cabin Admins
        reachable_cabin_admins.each do |cabin_admin|
          create(:attendance, camp: camp, cabin: cabin, user: cabin_admin)
        end

        # Create a non-reachable Cabin Admin for the second cabin
        create(:attendance, camp: camp, cabin: camp.cabins.second, user: create(:cabin_admin))

        # Create some extra child campers for other cabins,
        create_list(:attendance, 2, :by_child, camp: camp, cabin: camp.cabins.second)

        # Camps,
        create_list(:attendance, 2, :by_child, camp: season.camps.second)

        # and Tenants
        tenant = create(:user).tenant
        extra_camp = create(:camp, :with_cabins)
        extra_campers = [*create_list(:child, 2, tenant: tenant), *create_list(:user, 2, tenant: tenant)]

        extra_campers.each do |camper|
          create(:attendance, camp: extra_camp, user: camper)
        end

        example_request
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response_json['data'].map { |user_obj| user_obj['id'].to_i }).to eq(reachable_users.pluck(:id)) }
    end
  end
end
