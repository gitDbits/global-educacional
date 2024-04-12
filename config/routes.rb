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
        # get :checkout
      end

      resources :users, only: %i[show edit create update] do
        get :voucher

        collection do
          get :award
          get :report_participants
          get :report_id_paper
          get :report_list_presence
          match 'search_user' => 'home#home', via: %i[get post], as: :search_user
        end
      end

      resources :institutions do
        collection do
          match 'search_institution' => 'institution#institution', via: %i[get post], as: :search_institution
        end
      end
    end
  end
end
