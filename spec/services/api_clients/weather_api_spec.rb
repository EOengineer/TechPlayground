# frozen_string_literal: true

# TODO: VCR cassettes may be a better option than explicit mocks here - large API responses.

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

  describe '#forecast' do

    # rubocop:disable Layout/HashAlignment
    let(:api_response) do
      {
        "forecast"=>{
          "forecastday"=>
            [{
              "date"=>"2023-06-20",
              "date_epoch"=>1687219200,
              "day"=>
                {
                  "maxtemp_c"=>23.5,
                  "maxtemp_f"=>74.3,
                  "mintemp_c"=>17.8,
                  "mintemp_f"=>64.0,
                  "avgtemp_c"=>19.9,
                  "avgtemp_f"=>67.8,
                  "maxwind_mph"=>13.0,
                  "maxwind_kph"=>20.9,
                  "totalprecip_mm"=>12.7,
                  "totalprecip_in"=>0.5,
                  "totalsnow_cm"=>0.0,
                  "avgvis_km"=>6.6,
                  "avgvis_miles"=>4.0,
                  "avghumidity"=>89.0,
                  "daily_will_it_rain"=>1,
                  "daily_chance_of_rain"=>98,
                  "daily_will_it_snow"=>0,
                  "daily_chance_of_snow"=>0,
                  "condition"=>
                    {
                      "text"=>"Moderate rain",
                      "icon"=>"//cdn.weatherapi.com/weather/64x64/day/302.png",
                      "code"=>1189
                    },
                  "uv"=>4.0
                },
              "astro"=>
                {
                  "sunrise"=>"05:46 AM",
                  "sunset"=>"08:41 PM",
                  "moonrise"=>"07:36 AM",
                  "moonset"=>"11:06 PM",
                  "moon_phase"=>"Waxing Crescent",
                  "moon_illumination"=>"3",
                  "is_moon_up"=>1,
                  "is_sun_up"=>1
                },
              "hour"=>
                [
                  {
                    "time_epoch"=>1687233600,
                    "time"=>"2023-06-20 00:00",
                    "temp_c"=>18.8,
                    "temp_f"=>65.8,
                    "is_day"=>0,
                    "condition"=>
                      {
                        "text"=>"Fog",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/night/248.png",
                        "code"=>1135
                      },
                    "wind_mph"=>2.9,
                    "wind_kph"=>4.7,
                    "wind_degree"=>193,
                    "wind_dir"=>"SSW",
                    "pressure_mb"=>1016.0,
                    "pressure_in"=>30.01,
                    "precip_mm"=>0.0,
                    "precip_in"=>0.0,
                    "humidity"=>97,
                    "cloud"=>100,
                    "feelslike_c"=>18.8,
                    "feelslike_f"=>65.8,
                    "windchill_c"=>18.8,
                    "windchill_f"=>65.8,
                    "heatindex_c"=>18.8,
                    "heatindex_f"=>65.8,
                    "dewpoint_c"=>18.4,
                    "dewpoint_f"=>65.1,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>0,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>0.0,
                    "vis_miles"=>0.0,
                    "gust_mph"=>5.1,
                    "gust_kph"=>8.3,
                    "uv"=>1.0
                  },
                  {
                    "time_epoch"=>1687237200,
                    "time"=>"2023-06-20 01:00",
                    "temp_c"=>18.7,
                    "temp_f"=>65.7,
                    "is_day"=>0,
                    "condition"=>
                      {
                        "text"=>"Light rain shower",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/night/353.png",
                        "code"=>1240
                      },
                    "wind_mph"=>0.4,
                    "wind_kph"=>0.7,
                    "wind_degree"=>256,
                    "wind_dir"=>"WSW",
                    "pressure_mb"=>1016.0,
                    "pressure_in"=>30.01,
                    "precip_mm"=>0.7,
                    "precip_in"=>0.03,
                    "humidity"=>97,
                    "cloud"=>55,
                    "feelslike_c"=>18.7,
                    "feelslike_f"=>65.7,
                    "windchill_c"=>18.7,
                    "windchill_f"=>65.7,
                    "heatindex_c"=>18.7,
                    "heatindex_f"=>65.7,
                    "dewpoint_c"=>18.2,
                    "dewpoint_f"=>64.8,
                    "will_it_rain"=>1,
                    "chance_of_rain"=>98,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>10.0,
                    "vis_miles"=>6.0,
                    "gust_mph"=>0.9,
                    "gust_kph"=>1.4,
                    "uv"=>1.0
                  },
                  {
                    "time_epoch"=>1687240800,
                    "time"=>"2023-06-20 02:00",
                    "temp_c"=>18.6,
                    "temp_f"=>65.5,
                    "is_day"=>0,
                    "condition"=>
                      {
                        "text"=>"Mist",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/night/143.png",
                        "code"=>1030
                      },
                    "wind_mph"=>2.2,
                    "wind_kph"=>3.6,
                    "wind_degree"=>29,
                    "wind_dir"=>"NNE",
                    "pressure_mb"=>1016.0,
                    "pressure_in"=>30.01,
                    "precip_mm"=>0.0,
                    "precip_in"=>0.0,
                    "humidity"=>97,
                    "cloud"=>56,
                    "feelslike_c"=>18.6,
                    "feelslike_f"=>65.5,
                    "windchill_c"=>18.6,
                    "windchill_f"=>65.5,
                    "heatindex_c"=>18.6,
                    "heatindex_f"=>65.5,
                    "dewpoint_c"=>18.1,
                    "dewpoint_f"=>64.6,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>0,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>2.0,
                    "vis_miles"=>1.0,
                    "gust_mph"=>4.0,
                    "gust_kph"=>6.5,
                    "uv"=>1.0
                  },
                  {
                    "time_epoch"=>1687244400,
                    "time"=>"2023-06-20 03:00",
                    "temp_c"=>18.4,
                    "temp_f"=>65.1,
                    "is_day"=>0,
                    "condition"=>
                      {"text"=>"Patchy light drizzle",
                      "icon"=>"//cdn.weatherapi.com/weather/64x64/night/263.png",
                      "code"=>1150
                    },
                    "wind_mph"=>4.0,
                    "wind_kph"=>6.5,
                    "wind_degree"=>45,
                    "wind_dir"=>"NE",
                    "pressure_mb"=>1016.0,
                    "pressure_in"=>30.01,
                    "precip_mm"=>0.4,
                    "precip_in"=>0.02,
                    "humidity"=>98,
                    "cloud"=>74,
                    "feelslike_c"=>18.4,
                    "feelslike_f"=>65.1,
                    "windchill_c"=>18.4,
                    "windchill_f"=>65.1,
                    "heatindex_c"=>18.4,
                    "heatindex_f"=>65.1,
                    "dewpoint_c"=>18.0,
                    "dewpoint_f"=>64.4,
                    "will_it_rain"=>1,
                    "chance_of_rain"=>96,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>5.0,
                    "vis_miles"=>3.0,
                    "gust_mph"=>6.9,
                    "gust_kph"=>11.2,
                    "uv"=>1.0
                  },
                  {
                    "time_epoch"=>1687248000,
                    "time"=>"2023-06-20 04:00",
                    "temp_c"=>18.2,
                    "temp_f"=>64.8,
                    "is_day"=>0,
                    "condition"=>
                      {
                        "text"=>"Light drizzle",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/night/266.png",
                        "code"=>1153
                      },
                    "wind_mph"=>4.7,
                    "wind_kph"=>7.6,
                    "wind_degree"=>50,
                    "wind_dir"=>"NE",
                    "pressure_mb"=>1017.0,
                    "pressure_in"=>30.02,
                    "precip_mm"=>0.3,
                    "precip_in"=>0.01,
                    "humidity"=>98,
                    "cloud"=>88,
                    "feelslike_c"=>18.2,
                    "feelslike_f"=>64.8,
                    "windchill_c"=>18.2,
                    "windchill_f"=>64.8,
                    "heatindex_c"=>18.2,
                    "heatindex_f"=>64.8,
                    "dewpoint_c"=>17.9,
                    "dewpoint_f"=>64.2,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>69,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>2.0,
                    "vis_miles"=>1.0,
                    "gust_mph"=>7.8,
                    "gust_kph"=>12.6,
                    "uv"=>1.0
                  },
                  {
                    "time_epoch"=>1687251600,
                    "time"=>"2023-06-20 05:00",
                    "temp_c"=>18.0,
                    "temp_f"=>64.4,
                    "is_day"=>0,
                    "condition"=>
                      {
                        "text"=>"Light rain",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/night/296.png",
                        "code"=>1183
                      },
                    "wind_mph"=>4.3,
                    "wind_kph"=>6.8,
                    "wind_degree"=>56,
                    "wind_dir"=>"ENE",
                    "pressure_mb"=>1017.0,
                    "pressure_in"=>30.03,
                    "precip_mm"=>1.3,
                    "precip_in"=>0.05,
                    "humidity"=>98,
                    "cloud"=>88,
                    "feelslike_c"=>18.0,
                    "feelslike_f"=>64.4,
                    "windchill_c"=>18.0,
                    "windchill_f"=>64.4,
                    "heatindex_c"=>18.0,
                    "heatindex_f"=>64.4,
                    "dewpoint_c"=>17.7,
                    "dewpoint_f"=>63.9,
                    "will_it_rain"=>1,
                    "chance_of_rain"=>86,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>9.0,
                    "vis_miles"=>5.0,
                    "gust_mph"=>7.2,
                    "gust_kph"=>11.5,
                    "uv"=>1.0
                  },
                  {
                    "time_epoch"=>1687255200,
                    "time"=>"2023-06-20 06:00",
                    "temp_c"=>17.9,
                    "temp_f"=>64.2,
                    "is_day"=>1,
                    "condition"=>
                      {
                        "text"=>"Fog",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/day/248.png",
                        "code"=>1135
                      },
                    "wind_mph"=>4.5,
                    "wind_kph"=>7.2,
                    "wind_degree"=>60,
                    "wind_dir"=>"ENE",
                    "pressure_mb"=>1017.0,
                    "pressure_in"=>30.04,
                    "precip_mm"=>0.0,
                    "precip_in"=>0.0,
                    "humidity"=>98,
                    "cloud"=>100,
                    "feelslike_c"=>17.9,
                    "feelslike_f"=>64.2,
                    "windchill_c"=>17.9,
                    "windchill_f"=>64.2,
                    "heatindex_c"=>17.9,
                    "heatindex_f"=>64.2,
                    "dewpoint_c"=>17.6,
                    "dewpoint_f"=>63.7,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>0,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>0.0,
                    "vis_miles"=>0.0,
                    "gust_mph"=>7.8,
                    "gust_kph"=>12.6,
                    "uv"=>4.0
                  },
                  {
                    "time_epoch"=>1687258800,
                    "time"=>"2023-06-20 07:00",
                    "temp_c"=>17.9,
                    "temp_f"=>64.2,
                    "is_day"=>1,
                    "condition"=>
                      {
                        "text"=>"Light rain shower",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/day/353.png",
                        "code"=>1240
                      },
                    "wind_mph"=>4.7,
                    "wind_kph"=>7.6,
                    "wind_degree"=>59,
                    "wind_dir"=>"ENE",
                    "pressure_mb"=>1018.0,
                    "pressure_in"=>30.06,
                    "precip_mm"=>0.4,
                    "precip_in"=>0.02,
                    "humidity"=>98,
                    "cloud"=>85,
                    "feelslike_c"=>17.9,
                    "feelslike_f"=>64.2,
                    "windchill_c"=>17.9,
                    "windchill_f"=>64.2,
                    "heatindex_c"=>17.9,
                    "heatindex_f"=>64.2,
                    "dewpoint_c"=>17.6,
                    "dewpoint_f"=>63.7,
                    "will_it_rain"=>1,
                    "chance_of_rain"=>87,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>10.0,
                    "vis_miles"=>6.0,
                    "gust_mph"=>8.1,
                    "gust_kph"=>13.0,
                    "uv"=>4.0
                  },
                  {
                    "time_epoch"=>1687262400,
                    "time"=>"2023-06-20 08:00",
                    "temp_c"=>18.5,
                    "temp_f"=>65.3,
                    "is_day"=>1,
                    "condition"=>
                      {
                        "text"=>"Fog",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/day/248.png",
                        "code"=>1135
                      },
                    "wind_mph"=>5.4,
                    "wind_kph"=>8.6,
                    "wind_degree"=>66,
                    "wind_dir"=>"ENE",
                    "pressure_mb"=>1018.0,
                    "pressure_in"=>30.07,
                    "precip_mm"=>0.0,
                    "precip_in"=>0.0,
                    "humidity"=>98,
                    "cloud"=>100,
                    "feelslike_c"=>18.5,
                    "feelslike_f"=>65.3,
                    "windchill_c"=>18.5,
                    "windchill_f"=>65.3,
                    "heatindex_c"=>18.5,
                    "heatindex_f"=>65.3,
                    "dewpoint_c"=>18.1,
                    "dewpoint_f"=>64.6,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>0,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>0.0,
                    "vis_miles"=>0.0,
                    "gust_mph"=>8.3,
                    "gust_kph"=>13.3,
                    "uv"=>4.0
                  },
                  {
                    "time_epoch"=>1687266000,
                    "time"=>"2023-06-20 09:00",
                    "temp_c"=>19.4,
                    "temp_f"=>66.9,
                    "is_day"=>1,
                    "condition"=>
                      {
                        "text"=>"Mist",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/day/143.png",
                        "code"=>1030
                      },
                    "wind_mph"=>5.6,
                    "wind_kph"=>9.0,
                    "wind_degree"=>76,
                    "wind_dir"=>"ENE",
                    "pressure_mb"=>1019.0,
                    "pressure_in"=>30.09,
                    "precip_mm"=>0.0,
                    "precip_in"=>0.0,
                    "humidity"=>94,
                    "cloud"=>80,
                    "feelslike_c"=>19.4,
                    "feelslike_f"=>66.9,
                    "windchill_c"=>19.4,
                    "windchill_f"=>66.9,
                    "heatindex_c"=>19.4,
                    "heatindex_f"=>66.9,
                    "dewpoint_c"=>18.5,
                    "dewpoint_f"=>65.3,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>0,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>2.0,
                    "vis_miles"=>1.0,
                    "gust_mph"=>7.8,
                    "gust_kph"=>12.6,
                    "uv"=>4.0
                  },
                  {
                    "time_epoch"=>1687269600,
                    "time"=>"2023-06-20 10:00",
                    "temp_c"=>20.5,
                    "temp_f"=>68.9,
                    "is_day"=>1,
                    "condition"=>
                      {
                        "text"=>"Overcast",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/day/122.png",
                        "code"=>1009
                      },
                    "wind_mph"=>6.7,
                    "wind_kph"=>10.8,
                    "wind_degree"=>94,
                    "wind_dir"=>"E",
                    "pressure_mb"=>1019.0,
                    "pressure_in"=>30.09,
                    "precip_mm"=>0.0,
                    "precip_in"=>0.0,
                    "humidity"=>88,
                    "cloud"=>100,
                    "feelslike_c"=>20.5,
                    "feelslike_f"=>68.9,
                    "windchill_c"=>20.5,
                    "windchill_f"=>68.9,
                    "heatindex_c"=>20.5,
                    "heatindex_f"=>68.9,
                    "dewpoint_c"=>18.5,
                    "dewpoint_f"=>65.3,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>0,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>10.0,
                    "vis_miles"=>6.0,
                    "gust_mph"=>8.7,
                    "gust_kph"=>14.0,
                    "uv"=>5.0
                  },
                  {
                    "time_epoch"=>1687273200,
                    "time"=>"2023-06-20 11:00",
                    "temp_c"=>21.4,
                    "temp_f"=>70.5,
                    "is_day"=>1,
                    "condition"=>
                      {
                        "text"=>"Patchy rain possible",
                        "icon"=>"//cdn.weatherapi.com/weather/64x64/day/176.png",
                        "code"=>1063
                      },
                    "wind_mph"=>7.4,
                    "wind_kph"=>11.9,
                    "wind_degree"=>99,
                    "wind_dir"=>"E",
                    "pressure_mb"=>1019.0,
                    "pressure_in"=>30.1,
                    "precip_mm"=>0.1,
                    "precip_in"=>0.0,
                    "humidity"=>84,
                    "cloud"=>60,
                    "feelslike_c"=>21.4,
                    "feelslike_f"=>70.5,
                    "windchill_c"=>21.4,
                    "windchill_f"=>70.5,
                    "heatindex_c"=>24.3,
                    "heatindex_f"=>75.7,
                    "dewpoint_c"=>18.5,
                    "dewpoint_f"=>65.3,
                    "will_it_rain"=>0,
                    "chance_of_rain"=>58,
                    "will_it_snow"=>0,
                    "chance_of_snow"=>0,
                    "vis_km"=>10.0,
                    "vis_miles"=>6.0,
                    "gust_mph"=>9.2,
                    "gust_kph"=>14.8,
                    "uv"=>5.0
                  },
                ]
              }
            ]
          }
        }
    end
    # rubocop:enable Layout/HashAlignment

    before do
      allow(subject)
        .to receive(:make_request)
        .with(Net::HTTP::Get, described_class::API_SECTIONS[:forecast], query: subject.send(:weather_api_query_params))
        .and_return(api_response)
    end

    it 'calls get with the correct path and query params' do
      expect(subject)
        .to receive(:get)
        .with(path: described_class::API_SECTIONS[:forecast], query: subject.send(:weather_api_query_params))

      subject.forecast
    end

    it 'returns the forecast' do
      expect(subject.forecast).to eq(api_response)
    end
  end
end
# rubocop:enable Metrics/BlockLength
