# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampImportJob, type: :job do
  let(:import) { create(:camp_import) }

  describe 'calling perform' do
    it 'executes an Import::CampCSV instance' do
      expect_any_instance_of(Import::CampCSV).to receive(:execute)

      described_class.perform_now(import)
    end
  end
end
