# frozen_string_literal: true

Rails.application.routes.draw do
  localized do # rubocop:disable Metrics/BlockLength
    root 'guest#home'

    get 'courses/admin'
    get 'courses/accounting'
    get 'courses/public_management'
    get 'courses/pedagogy'
    get '/cep/:zipcode', to: 'cep#show'

    namespace :portal do # rubocop:disable Metrics/BlockLength
      resources :events do
        get :checkout
      end

      resources :users, only: :create
    end
  end
end
