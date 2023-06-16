# frozen_string_literal: true

module API
  class WeatherController < API::BaseController
    def index
      render json: weather_api_client.current_weather
    end

    private

    def weather_api_client
      @weather_api_client ||= ::APIClients::WeatherAPI.new(zip_code: zip_code)
    end

    def zip_code
      params[:zip_code] || ::APIClients::WeatherAPI::DEFAULT_LOCATION_IDENTIFIER
    end
  end
end