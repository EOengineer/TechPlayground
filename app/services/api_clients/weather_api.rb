# frozen_string_literal: true

require 'net/http'

module ApiClients
  class WeatherApi < Base
    API_SECTIONS = {
      current: 'current.json',
      forecast: 'forecast.json',
      future: 'future.json',
      astronomy: 'astronomy.json',
      time_zone: 'timezone.json'
    }.freeze

    DEFAULT_LOCATION_IDENTIFIER = '22602'
    TOKEN = Rails.application.credentials.weather.api_key

    attr_reader :zip_code

    def initialize(zip_code: DEFAULT_LOCATION_IDENTIFIER)
      super()
      @zip_code = zip_code
    end

    def current_weather
      get path: API_SECTIONS[:current], query: weather_api_query_params
    end

    def forecast
      get path: API_SECTIONS[:forecast], query: weather_api_query_params
    end

    def future_weather
      get path: API_SECTIONS[:future], query: weather_api_query_params
    end

    def astronomy
      get path: API_SECTIONS[:astronomy], query: weather_api_query_params
    end

    def time_zone
      get path: API_SECTIONS[:time_zone], query: weather_api_query_params
    end

    private

    # override
    def base_url
      Rails.application.credentials.weather.api_base_url
    end

    def weather_api_query_params
      { key: TOKEN, q: zip_code }
    end
  end
end
