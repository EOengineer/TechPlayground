# frozen_string_literal: true

# TODO: VCR cassettes may be a better option than explicit mocks here - large API responses.

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe APIClients::WeatherAPI, :vcr do
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
        expect { subject }.to raise_error(APIClients::MissingRequiredArgumentError)
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

  describe '#current_weather' do
    it 'calls get with the correct path and query params' do
      expect(subject)
        .to receive(:get)
        .with(path: described_class::API_SECTIONS[:current], query: subject.send(:weather_api_query_params))

      subject.current_weather
    end

    it 'returns the current weather' do
      expect(subject.current_weather).to have_key('current')
    end
  end

  describe '#forecast' do
    it 'calls get with the correct path and query params' do
      expect(subject)
        .to receive(:get)
        .with(path: described_class::API_SECTIONS[:forecast], query: subject.send(:weather_api_query_params))

      subject.forecast
    end

    it 'returns the forecast' do
      expect(subject.forecast).to have_key('forecast')
    end
  end

  describe '#astronomy' do
    it 'calls get with the correct path and query params' do
      expect(subject)
        .to receive(:get)
        .with(path: described_class::API_SECTIONS[:astronomy], query: subject.send(:weather_api_query_params))

      subject.astronomy
    end

    it 'returns the future weather' do
      expect(subject.astronomy).to have_key('astronomy')
    end
  end
end
# rubocop:enable Metrics/BlockLength
