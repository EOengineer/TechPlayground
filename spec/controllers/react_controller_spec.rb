# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactController do
  describe '#home' do
    it 'returns a 200' do
      expect(response).to have_http_status(:ok)
    end
  end
end
