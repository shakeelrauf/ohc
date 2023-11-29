# frozen_string_literal: true

require 'rails_helper'

shared_examples 'object with slug' do
  describe '#generate_slug' do
    it { expect(object.slug).to eq(object.name.parameterize) }
  end
end
