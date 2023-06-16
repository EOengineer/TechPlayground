# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe ApiClients::WeatherApi do
  subject { described_class.new(zip_code: zip_code) }
  let(:zip_code) { '22602' }

  describe 'initialization' do
    context 'with a zip code' do
      it 'is initialized without an error' do
        expect { subject }.not_to raise_error
      end
    end

    context 'without a zip code' do
      let(:zip_code) { nil }

      it 'is initialized without an error' do
        expect { subject }.to raise_error(ApiClients::MissingRequiredArgumentError)
      end
    end
  end

  describe 'overrides' do
    it 'has a base url' do
      expect(subject.send(:base_url)).to eq Rails.application.credentials.weather.api_base_url
    end

    it 'has headers' do
      expect(subject.send(:headers)).to eq('Accept' => 'application/json', 'Content-Type' => 'application/json')
    end

    it 'has weather api query params' do
      expect(subject.send(:weather_api_query_params))
        .to eq(key: Rails.application.credentials.weather.api_key, q: zip_code)
    end
  end
end
# rubocop:enable Metrics/BlockLength
