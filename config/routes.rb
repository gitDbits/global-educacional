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
    get 'events/:id', to: 'portal/events#show', as: 'event'
    get 'events/:id/checkout', to: 'portal/events#checkout', as: 'event_checkout'
    get 'events', to: 'portal/events#index', as: 'events'

    namespace :portal do # rubocop:disable Metrics/BlockLength
      get 'home', to: 'home#home'

      resources :users, only: %i[show edit create update] do
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

      resources :subscription_events do
        get :voucher

        collection do
          match 'search_subscription_event' => 'subscription_events#subscription_event', via: %i[get post], as: :search_subscription_event
        end
      end

      resources :events do
        get :collection, on: :collection

        collection do
          match 'search_event' => 'events#event', via: %i[get post], as: :search_event
        end
      end
    end
  end
end
