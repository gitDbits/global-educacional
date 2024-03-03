# frozen_string_literal: true

Rails.application.routes.draw do
  localized do # rubocop:disable Metrics/BlockLength
    root 'guest#home'

    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

    get 'courses/admin'
    get 'courses/accounting'
    get 'courses/public_management'
    get 'courses/pedagogy'
    get '/cep/:zipcode', to: 'cep#show'

    namespace :portal do # rubocop:disable Metrics/BlockLength
      get 'home', to: 'home#home'

      resources :events do
        get :checkout
      end

      resources :users, only: :create do
        get :voucher
        collection do
          match 'search_user' => 'home#home', via: %i[get post], as: :search_user
        end
      end
    end
  end
end
