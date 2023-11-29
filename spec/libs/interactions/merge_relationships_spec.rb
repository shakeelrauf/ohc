# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interactions::MergeRelationships do
  describe '#execute' do
    let(:source) { create(:child) }
    let(:destination) { create(:child) }
    let(:interaction) { described_class.new(source, destination) }

    # Relationships
    let(:attendance) { create(:attendance, user: source) }
    let(:contact_email_message) { create(:contact_email_message, user: source) }
    let(:media_item) { create(:media_item, user: source) }
    let(:score) { create(:score, user: source) }
    let(:theme_score) { create(:score, :for_theme, user: source) }
    let(:camper_question) { create(:camper_question, child: source) }

    context 'valid classes' do
      before do
        attendance
        contact_email_message
        media_item
        score
        theme_score
        camper_question
        interaction.execute
      end

      it 'fetches the correct relationships' do
        expected_result = [
          ['attendances', 'user_id'],
          ['contact_email_messages', 'user_id'],
          ['media_items', 'user_id'],
          ['scores', 'user_id'],
          ['theme_scores', 'user_id'],
          ['camper_questions', 'child_id']
        ]

        expect(interaction.send(:has_many_relationships)).to eq(expected_result)
      end

      it 'moves attendance' do
        expect(attendance.reload.user_id).to eq(destination.id)
      end

      it 'moves contact_email_message' do
        expect(contact_email_message.reload.user_id).to eq(destination.id)
      end

      it 'moves media_item' do
        expect(media_item.reload.user_id).to eq(destination.id)
      end

      it 'moves score' do
        expect(score.reload.user_id).to eq(destination.id)
      end

      it 'moves theme_score' do
        expect(theme_score.reload.user_id).to eq(destination.id)
      end

      it 'moves camper_question' do
        expect(camper_question.reload.child_id).to eq(destination.id)
      end

      it 'removes the source user' do
        expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'unmatched classes' do
      let(:destination) { create(:admin) }

      it 'raises error' do
        expect { interaction.send(:validate_matching_classes) }.to raise_error(Interactions::MergeError)
      end
    end
  end
end
