# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import, type: :model do
  it { is_expected.to belong_to(:scope) }

  it { is_expected.to validate_attached_of(:csv_file) }
  it { is_expected.to validate_content_type_of(:csv_file).allowing(%w[text/csv application/csv application/vnd.ms-excel]) }
  it { is_expected.to validate_numericality_of(:percent_completion).only_integer }
  it { is_expected.to validate_inclusion_of(:percent_completion).in_range(0..100).allow_nil }

  describe '#queue!' do
    let(:scope) { create(:camp, :with_cabins) }
    let(:valid_csv) { fixture_file('Test Sheet - Camp.csv', 'text/csv') }
    let(:import) { build(:camp_import, csv_file: valid_csv, scope: scope)}

    let(:job_double) { class_double(CampImportJob).as_stubbed_const }

    before do
      allow(job_double).to receive(:perform_later) { OpenStruct.new(provider_job_id: 1) }

      import.save
    end

    it 'queues the job' do
      expect(job_double).to have_received(:perform_later).with(instance_of(described_class))
    end

    it { expect(import.valid?).to be(true) }

    context 'with invalid arguments' do
      let(:scope) { nil }

      it 'does not queue a job' do
        expect(job_double).not_to have_received(:perform_later)
      end

      it { expect(import.valid?).to be(false) }
    end
  end
end
