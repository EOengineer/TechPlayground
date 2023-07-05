# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'application#home'

  get '/hotwire', to: 'hotwire#home', as: :hotwire_home
  get '/react', to: 'react#home', as: :react_home

  namespace :api, constraints: { format: 'json' } do
    get '/weather', to: 'weather#index', as: :weather_index
    resources :questions, only: [:create]
  end
end
