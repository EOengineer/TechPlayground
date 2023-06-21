# frozen_string_literal: true

module API
  class QuestionsController < API::BaseController
    def create
      question = params[:question]
      if question.blank?
        render json: { error: 'Question is required' }, status: :unprocessable_entity
      else
        answer = APIClients::ChatClient.ask(question)
        render json: { answer: answer }, status: :ok
      end
    end
  end
end
