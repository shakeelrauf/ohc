# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stream, type: :model do
  let(:unsaved_stream) { build(:stream) }
  let(:stream) { create(:stream, :with_stop, :with_start) }

  it { is_expected.to belong_to(:event).optional }

  it { is_expected.to validate_presence_of(:name) }

  it_behaves_like 'object with slug' do
    let(:object) { stream }
  end

  describe '#create_media_live_input' do
    it 'correctly sets aws_input_id' do
      unsaved_stream.send(:create_media_live_input)

      expect(unsaved_stream.aws_input_id).not_to eq(nil)
    end
  end

  describe '#create_media_live_channel' do
    it 'correctly sets aws_channel_id' do
      unsaved_stream.send(:create_media_live_channel)

      expect(unsaved_stream.aws_channel_id).not_to eq(nil)
    end
  end

  describe '#start!' do
    it 'returns without error' do
      expect(stream.start!).not_to eq(nil)
    end
  end

  describe '#stop!' do
    it 'returns without error' do
      expect(stream.stop!).not_to eq(nil)
    end
  end
end
