# frozen_string_literal: true

OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai.access_token
end
