# frozen_string_literal: true

require 'rails_helper'

describe APIClients::Base do
  describe 'http methods' do
    subject { described_class.new }
    let(:query_params) { { key: 'value' } }

    describe '#delete' do
      it 'raises NotImplementedError' do
        expect { subject.delete(path: 'path', query: query_params) }.to raise_error(NotImplementedError)
      end
    end

    describe '#get' do
      it 'raises NotImplementedError' do
        expect { subject.get(path: 'path', query: query_params) }.to raise_error(NotImplementedError)
      end
    end

    describe '#patch' do
      it 'raises NotImplementedError' do
        expect { subject.patch(path: 'path', query: query_params) }.to raise_error(NotImplementedError)
      end
    end

    describe '#post' do
      it 'raises NotImplementedError' do
        expect { subject.post(path: 'path', query: query_params) }.to raise_error(NotImplementedError)
      end
    end

    describe '#put' do
      it 'raises NotImplementedError' do
        expect { subject.put(path: 'path', query: query_params) }.to raise_error(NotImplementedError)
      end
    end
  end
end
