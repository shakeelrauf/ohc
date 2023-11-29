# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:tenant) { create(:tenant, max_streams: 1, max_stream_hours: 1) }
  let(:stream) { create(:stream, :with_start, :with_stop) }
  let(:event) { create(:event, tenant: tenant) }

  it { is_expected.to belong_to(:admin) }
  it { is_expected.to have_one(:stream) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:ends_at) }

  it { is_expected.to validate_content_type_of(:thumbnail).allowing(['image/png', 'image/jpg', 'image/jpeg']) }
  it { is_expected.to validate_size_of(:thumbnail).less_than(20.megabytes) }

  describe '.total_duration' do
    it 'returns the total duration of all finished events' do
      started_at = Time.current
      ended_at = started_at + 1.hour

      event.update!(started_at: started_at, ended_at: ended_at, status: 'finished')

      expected_result = ended_at.to_i - started_at.to_i

      expect(described_class.total_duration).to eq(expected_result)
    end
  end

  it_behaves_like 'object with slug' do
    let(:object) { event }
  end

  describe '#start!' do
    context 'when streams available' do
      before do
        stream
        event.start!
      end

      it 'sets the correct state' do
        expect(event.started?).to eq(true)
      end

      it 'associates a stream' do
        expect(event.stream).to eq(stream)
      end
    end

    context 'when streams taken' do
      let(:another_event) { create(:event) }

      before do
        stream.update(event: another_event)
      end

      it 'adds an error to the object' do
        event.start!

        expect(event.errors[:base]).to eq(['No streams are currently available'])
      end
    end

    context 'when over max' do
      let(:another_event) { create(:event, tenant: tenant) }
      let(:another_stream) { create(:stream, :with_start, :with_stop) }

      before do
        stream.update(event: another_event)
        another_stream
      end

      it 'adds an error to the object' do
        event.start!

        expect(event.errors[:base]).to eq(['Maximum number of active streams reached'])
      end
    end
  end

  describe '#stop!' do
    before do
      stream
      event.start!
    end

    context 'when under quota' do
      it 'sets the correct state' do
        event.stop!
        expect(event.finished?).to eq(true)
      end

      it 'removes the association' do
        event.stop!
        expect(event.stream).to eq(nil)
      end

      it 'hides the event' do
        event.stop!
        expect(event.active?).to eq(false)
      end

      it 'doesnt trigger a warning email' do
        expect { event.stop! }.not_to have_enqueued_job.on_queue('mailers')
      end
    end

    context 'when over 80% of quota' do
      it 'triggers a warning email when over 90% of quota' do
        create(:national_event, tenant: tenant,
                                started_at: Time.now,
                                ended_at: (Time.now + (tenant.max_stream_hours.to_i * 0.9).hours),
                                status: 'finished')

        expect { event.stop! }.to have_enqueued_job.on_queue('mailers')
      end
    end
  end
end
