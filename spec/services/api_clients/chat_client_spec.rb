# frozen_string_literal: true

# TODO: VCR cassettes may be a better option than explicit mocks here - large API responses.

require 'rails_helper'

describe APIClients::ChatClient, :vcr do
  subject { described_class }
  let(:question) { 'what is pi rounded to 3 decimal positions?' }

  describe '#ask' do
    context 'with a question' do
      it 'returns the current weather' do
        expect(subject.ask(question)).to eq('Pi rounded to 3 decimal positions is 3.142.')
      end
    end

    context 'without a question' do
      it 'returns the current weather' do
        expect { subject.ask(nil) }.to raise_error(APIClients::MissingRequiredArgumentError)
      end
    end
  end
end
