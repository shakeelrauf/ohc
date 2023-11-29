# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V2::MediaItemsController, type: :request do
  describe 'Retrieve an index of media items' do
    let(:child) { create(:child) }
    let(:attendance) { create(:attendance, user: child) }

    let(:camp_media_items) { create_list(:media_item, 2, tenant: child.tenant, camp: attendance.camp) }
    let(:other_camp_media_items) { create_list(:media_item, 2) }

    let(:example_request) { get '/api/v2/media_items.json', headers: auth_headers(child), as: :json }

    before do
      camp_media_items
      other_camp_media_items

      example_request
    end

    it { expect(response).to have_http_status(:ok) }

    it 'returns any media items for my camp' do
      expect(response_json['data'].map { |theme| theme['id'].to_i }).to include(*camp_media_items.map(&:id))
    end

    it 'excludes media items for other camps' do
      expect(response_json['data'].map { |theme| theme['id'].to_i }).not_to include(*other_camp_media_items.map(&:id))
    end

    it 'excludes any inactive media items' do
      inactive_media_items = create_list(:media_item, 2, tenant: child.tenant, active: false, camp: attendance.camp)

      expect(response_json['data'].map { |theme| theme['id'].to_i }).not_to include(*inactive_media_items.map(&:id))
    end
  end
end
