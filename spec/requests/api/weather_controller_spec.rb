# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::WeatherController, :vcr do
  let(:zip_code) { '20500' }

  describe 'GET #index' do
    before do
      get api_weather_index_url, params: { zip_code: zip_code }
    end

    describe 'response status' do
      subject { response }

      it { is_expected.to have_http_status(:ok) }
    end

    describe 'response body' do
      subject { JSON.parse(response.body) }

      it { is_expected.to have_key('current') }
      it { is_expected.to have_key('forecast') }
      it { is_expected.to have_key('astronomy') }
      it { is_expected.to have_key('time_zone') }
    end
  end
end
