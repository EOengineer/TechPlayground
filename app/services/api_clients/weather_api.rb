# frozen_string_literal: true

require 'net/http'

module ApiClients
  class WeatherApi
    API_SECTIONS = {
      current: 'current.json',
      forecast: 'forecast.json',
      future: 'future.json',
      astronomy: 'astronomy.json',
      time_zone: 'timezone.json'
    }.freeze

    BASE_URL = Rails.application.credentials.weather.api_base_url
    TOKEN = Rails.application.credentials.weather.api_key

    attr_reader :section, :zip_code

    def initialize(zip_code: '22602')
      @zip_code = zip_code
    end

    def current_weather
      get path: API_SECTIONS[:current]
    end

    def forecast
      get path: API_SECTIONS[:forecast]
    end

    def future_weather
      get path: API_SECTIONS[:future]
    end

    def astronomy
      get path: API_SECTIONS[:astronomy]
    end

    def time_zone
      get path: API_SECTIONS[:time_zone]
    end

    protected

    def get(path:)
      uri = build_uri(path)

      http = build_connection(uri)

      request = Net::HTTP::Get.new(uri.request_uri, headers)

      response = http.request(request)

      JSON.parse(response.body) if response.body.present?
    end

    def headers
      { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    end

    def build_uri(path)
      uri = URI(BASE_URL + path)
      uri.query = Rack::Utils.build_query({ key: TOKEN, q: zip_code })
      uri
    end

    def build_connection(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.instance_of?(URI::HTTPS)
      http
    end
  end
end
