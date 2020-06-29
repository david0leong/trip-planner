# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'countries/:code' => 'countries#show', :constraints => { code: /[a-z]{3}/i }
      get 'countries/capitals' => 'countries#capitals'
      get 'countries/visit' => 'countries#visit'
    end
  end
end
