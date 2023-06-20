# frozen_string_literal: true

module API
  class WeatherController < API::BaseController
    def index
      render json: {
        current: weather_api_client.current_weather,
        forecast: weather_api_client.forecast,
        astronomy: weather_api_client.astronomy,
        time_zone: weather_api_client.time_zone
      }
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
