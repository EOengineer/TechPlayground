# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe APIClients::WeatherAPI do
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
    let(:api_response) do
      {
        'location': {
          'name': 'Winchester',
          'region': 'Virginia',
          'country': 'USA',
          'lat': 39.17,
          'lon': -78.15,
          'tz_id': 'America/New_York',
          'localtime_epoch': 1686939818,
          'localtime': '2023-06-16 14:23'
        },
        'current': {
          'last_updated_epoch': 1686939300,
          'last_updated': '2023-06-16 14:15',
          'temp_c': 21.0,
          'temp_f': 69.8,
          'is_day': 1,
          'condition': {'text': 'Sunny', 'icon': '//cdn.weatherapi.com/weather/64x64/day/113.png', 'code': 1000},
          'wind_mph': 2.2,
          'wind_kph': 3.6,
          'wind_degree': 10,
          'wind_dir': 'N',
          'pressure_mb': 1005.0,
          'pressure_in': 29.67,
          'precip_mm': 5.3,
          'precip_in': 0.21,
          'humidity': 69,
          'cloud': 0,
          'feelslike_c': 21.0,
          'feelslike_f': 69.8,
          'vis_km': 16.0,
          'vis_miles': 9.0,
          'uv': 5.0,
          'gust_mph': 5.4,
          'gust_kph': 8.6
        }
      }
    end

    before do
      allow(subject)
        .to receive(:make_request)
        .with(Net::HTTP::Get, described_class::API_SECTIONS[:current], query: subject.send(:weather_api_query_params))
        .and_return(api_response)
    end

    it 'calls get with the correct path and query params' do
      expect(subject)
        .to receive(:get)
        .with(path: described_class::API_SECTIONS[:current], query: subject.send(:weather_api_query_params))

      subject.current_weather
    end

    it 'returns the current weather' do
      expect(subject.current_weather).to eq(api_response)
    end
  end
end
# rubocop:enable Metrics/BlockLength
