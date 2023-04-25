# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'react#home'

  get '/hotwire/home', to: 'hotwire#home'
  get '/react/home', to: 'react#home'
end
