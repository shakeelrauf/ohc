# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::CampCSV do
  include_context 'with cometchat calls'

  let(:tenant) { create(:tenant) }

  # Constants derived from the Camp CSV Fixture
  let(:admin_rows) { 2 }
  let(:new_child_rows) { 4 }
  let(:children_already_in_camp) { 2 }
  let(:red_cabin_children) { 4 }
  let(:blue_cabin_children) { 2 }
  let!(:camp_admin) { create(:camp_admin, email: 'camp.admin@test.com', tenant: tenant) }
  let!(:cabin_admin) { create(:cabin_admin, email: 'cabin.admin@test.com', tenant: tenant) }

  let(:import) { create(:camp_import, tenant: tenant) }
  let(:camp) { import.scope }
  let(:cabin_names) { ['Red Team', 'Blue Team'] }

  before do
    # Create cabins specified in the CSV
    csv_cabins = cabin_names.map { |cabin_name| create(:cabin, camp: camp, name: cabin_name) }

    # Create a Child that is already correctly in its CSV Cabin
    # NOTE: This may no longer be true if the `Test Sheet - Camp.csv` file is changed.
    child_in_cabin = create(:child, first_name: 'Sara',
                                    last_name: 'Power',
                                    date_of_birth: '2010-06-01',
                                    gender: 'female',
                                    email: 'sara.parent@test.com',
                                    tenant: tenant)

    csv_cabins.first.attendances.create!(user: child_in_cabin)

    # Create an extra Cabin that is not specified in the CSV
    non_csv_cabin = create(:cabin, camp: camp)

    # Create a Child that is in this camp, but not in the correct Cabin
    # NOTE: This may no longer be true if the `Test Sheet - Camp.csv` file is changed.
    child_in_camp = create(:child, first_name: 'Gillian',
                                   last_name: 'Marín',
                                   date_of_birth: '2010-06-02',
                                   gender: 'female',
                                   email: 'gillian.parent@test.com',
                                   tenant: tenant)

    non_csv_cabin.attendances.create!(user: child_in_camp)
  end

  describe 'execute' do
    let(:example_action) { described_class.new(import).execute }

    it { expect { example_action }.to change(User::Child, :count).by(new_child_rows) }
    it { expect { example_action }.not_to change(User::Admin, :count) }
    it { expect { example_action }.to change(camp.reload.attendances, :count).by(admin_rows + new_child_rows) }
    it { expect { example_action }.to change(camp.reload.attendances.of_admins, :count).by(admin_rows) }

    it 'adds the records to the correct camp' do
      example_action

      expect(camp.children.size).to eq(children_already_in_camp + new_child_rows)
      expect(camp.admins.camp_admin.to_a).to eq([camp_admin])
      expect(camp.admins.cabin_admin.to_a).to eq([cabin_admin])
    end

    describe 'adds the records to the correct cabins' do
      before { example_action }

      it { expect(Cabin.find_by(name: cabin_names.first).children.size).to eq(red_cabin_children) }
      it { expect(Cabin.find_by(name: cabin_names.second).children.size).to eq(blue_cabin_children) }
    end

    context 'with incorrect cabin names' do
      let(:cabin_names) { ['Blue team'] }

      it { expect { example_action }.not_to change(User::Child, :count) }
      it { expect { example_action }.not_to change(camp.reload.attendances, :count) }

      it 'adds the correct error to the import record' do
        example_action

        expect(camp.imports.first.error).to eq("Row 2: Cabin 'Red Team' could not be found.")
      end
    end
  end
end
