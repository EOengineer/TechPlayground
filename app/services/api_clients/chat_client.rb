# frozen_string_literal: true

module APIClients
  class ChatClient
    class << self
      def ask(question)
        raise MissingRequiredArgumentError, 'question is required' if question.blank?

        message_to_chat_api(question)
      end

      def message_to_chat_api(message_content)
        response = openai_client.chat(parameters:
        {
          model: 'gpt-3.5-turbo',
          messages: [{ role: 'user', content: message_content }],
          temperature: 0.5
        })
        response.dig('choices', 0, 'message', 'content')
      end

      def openai_client
        @openai_client ||= OpenAI::Client.new
      end
    end
  end

  class MissingRequiredArgumentError < StandardError; end
end

# Usage:
# ChatClient.ask("Your question..")
