# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Camp::CSV do
  describe 'generating a CSV from a camp' do
    let(:camp) { create(:camp, :with_cabins) }
    let!(:admin_attendance) { create(:attendance, :by_admin, camp: camp) }
    let!(:child_attendances) { create_list(:attendance, 3, camp: camp) }

    let(:generated_csv) { described_class.generate(camp) }

    let(:lines_including_header) { 5 }

    it { expect(generated_csv).to include(admin_attendance.code) }
    it { expect(generated_csv.lines.size).to eq(lines_including_header) }

    it 'contains all the children' do
      child_attendances.each do |child_attendance|
        expect(generated_csv).to include(child_attendance.code)
      end
    end

    context 'when camp has no attendances' do
      let(:generated_csv) { described_class.generate(create(:camp)) }

      it { expect(generated_csv.lines.size).to eq(1) }
    end
  end
end
