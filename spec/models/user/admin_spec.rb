# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Admin, type: :model do
  it { is_expected.to have_many(:camper_questions).dependent(:nullify) }
  it { is_expected.to have_many(:events).dependent(:restrict_with_error) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe 'belongs_to :camp_location' do
    context 'when super admin' do
      let(:super_admin) { build(:super_admin, camp_location_id: nil) }

      it 'is not presence validated' do
        expect(super_admin).to be_valid
      end
    end

    context 'when super admin' do
      let(:camp_admin) { build(:camp_admin, camp_location_id: nil) }

      it 'is not presence validated' do
        expect(camp_admin).not_to be_valid
      end
    end
  end
end
