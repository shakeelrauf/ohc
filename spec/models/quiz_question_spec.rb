# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuizQuestion, type: :model do
  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:scores).dependent(:destroy) }
  it { is_expected.to belong_to(:theme) }

  describe '#validate_answers' do
    let(:quiz_question) { build(:quiz_question) }

    before do
      quiz_question.answers.destroy_all
    end

    it 'is has no answers' do
      expect(quiz_question.answers.size).to eq(0)
    end

    it 'is not valid with no answers' do
      expect(quiz_question.valid?).to eq(false)
    end
  end
end
