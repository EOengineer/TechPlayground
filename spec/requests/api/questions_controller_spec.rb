# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::QuestionsController, :vcr do
  describe 'GET #index' do
    before do
      post api_questions_url, params: { question: question }
    end

    context 'with valid input' do
      let(:question) { 'What are the primary colors' }

      describe 'response status' do
        subject { response }

        it { is_expected.to have_http_status(:ok) }
      end

      describe 'response body' do
        subject { JSON.parse(response.body) }

        it { is_expected.to eq({ 'answer' => 'The primary colors are red, blue, and yellow.' }) }
      end
    end

    context 'with invalid input' do
      let(:question) { nil }

      describe 'response status' do
        subject { response }

        it { is_expected.to have_http_status(:unprocessable_entity) }
      end

      describe 'response body' do
        subject { JSON.parse(response.body) }

        it { is_expected.to eq({ 'error' => 'Question is required' }) }
      end
    end
  end
end
