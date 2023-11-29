# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to belong_to(:authentication).optional }
  it { is_expected.to belong_to(:device_token).optional }
  it { is_expected.to belong_to(:tenant) }

  it { is_expected.to have_many(:attendances) }
  it { is_expected.to have_many(:cabins).through(:attendances) }
  it { is_expected.to have_many(:camps).through(:attendances) }
  it { is_expected.to have_many(:camp_locations).through(:camps) }
  it { is_expected.to have_many(:seasons).through(:camps) }
  it { is_expected.to have_many(:contact_email_messages) }
  it { is_expected.to have_many(:media_items).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:scores).dependent(:destroy) }
  it { is_expected.to have_many(:theme_scores).class_name('Score') }

  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:gender) }

  describe '#validate_max_users' do
    let(:tenant) { create(:tenant, max_users: 1) }
    let(:user) { build(:user, tenant: tenant) }
    let(:another_user) { build(:user, tenant: tenant) }

    context 'when under the max number of users for the tenant' do
      it 'is valid' do
        expect(user.valid?).to eq(true)
      end
    end

    context 'when over the max number of users for the tenant' do
      before do
        user.save
      end

      it 'is invalid' do
        expect(another_user.valid?).to eq(false)
      end

      it 'adds an error' do
        another_user.valid?

        expect(another_user.errors[:base]).to eq(['You have reached the maximum number of users for your plan'])
      end
    end
  end

  describe '#cleanup_authentication' do
    let(:authentication) { create(:authentication) }
    let(:child) { create(:child, authentication: authentication) }

    context 'when one user' do
      before do
        child.destroy
      end

      it 'destroys the user' do
        expect { child.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'destroys the authentication' do
        expect { authentication.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when multiple users' do
      let(:another_child) { create(:child, authentication: authentication) }

      before do
        another_child
        child.destroy
      end

      it 'destroys the user' do
        expect { child.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'does not destroy the authentication' do
        expect(authentication.reload).to eq(authentication)
      end

      it 'does not destroy the other user' do
        expect(another_child.reload).to eq(another_child)
      end
    end

    context 'when no users' do
      before do
        child.destroy
      end

      it 'destroys the user' do
        expect { child.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
