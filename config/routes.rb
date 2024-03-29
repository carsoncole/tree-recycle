Rails.application.routes.draw do
  match "(*any)",
    to: redirect(subdomain: ""),
    via: :all,
    constraints: { subdomain: "www" } unless Rails.env.test?\

  root 'home#index'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end

  resources :remind_mes, only: [:show, :create]

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  get '/about' => 'home#about', as: 'about'
  get '/questions' => 'home#questions', as: 'questions'
  get '/search' => 'reservations#search', as: 'reservation_lookup'
  post '/search' => 'reservations#search'

  get '/donation' => 'donations#donation_without_reservation', as: 'donation_without_reservation'
  get '/thank-you-for-your-donation' => 'donations#success', as: 'success'

  get '/software' => 'home#software', as: 'software'

  post 'messages/reply' => 'messages#reply'

  get '/tree-program', to: redirect('/about') # this redirect old web links to this site

  get '/sitemap.xml', to: 'sitemap#index', as: 'sitemap', :defaults => {:format => 'xml'}

  resources :reservations, except: [:index] do
    get 'address-verification', as: 'address_verification'

    resources :donations, only: %i[ new create ]
    post 'cash-or-check' => 'donations#cash_or_check', as: 'cash_or_check'
    post 'no-donation' => 'donations#no_donation', as: 'no_donation'
    get 'donations/success' => 'donations#success', as: 'success'
    get 'donations/cancel' => 'donations#cancel', as: 'cancel'
    get 'confirmed' => 'reservations#confirmed', as: 'confirmed'


    post 'submit-reservation' => 'reservations#submit_confirmed_reservation', as: 'submit'
    get 'unsubscribe' => 'reservations#unsubscribe', as: 'unsubscribe'
    get 'resubscribe' => 'reservations#resubscribe', as: 'resubscribe'
  end

  post 'stripe-webhook' => "donations#stripe_webhook"

  namespace :driver do
    root 'zones#index'
    get 'instructions' => 'routes#instructions', as: 'instructions'
    get 'contact' => 'contact#index', as: 'contacts'
    get 'reservations/map' => 'reservations#map', as: 'reservations_map'
    get 'search' => 'reservations#search', as: 'search'
    resources :reservations, only: %i( update show ) do
      get 'map' => 'reservations#map', as: 'map'
    end
    resources :routes, only: %i( show index )
    resources :drivers, only: %i( index show )
    get '/routing' => 'zones#index', as: 'routing'
    get '/zones' => 'zones#index', as: 'zones'
  end

  namespace :admin do
    root 'admin#index'
    get 'operations/index' => 'operations#index', as: 'operations'
    patch 'operations/update'
    get '/routes/map-all' => 'routes#map_all', as: 'routes_map_all'
    resources :zones
    resources :drivers
    get 'logs' => 'logs#index', as: :logs
    resources :messages, only: [:index, :create, :destroy ]
    resources :marketing, only: [ :index ]
    resources :remind_mes, only: [ :index, :destroy ]

    resources :settings, only: [ :index, :edit, :update ]


    resources :users, only: [ :index, :update, :create, :destroy, :edit ]
    resources :driver_routes, only: [:create, :destroy]
    resources :points, only: [:create, :update, :destroy, :edit]
    delete 'reservations/archive-all' => 'reservations#post_event_archive', as: 'post_event_archive_reservations'
    delete 'reservations/destroy-all' => 'reservations#destroy_all', as: 'destroy_all_reservations'
    delete 'donations/destroy-all' => 'donations#destroy_all', as: 'destroy_all_donations'
    delete 'reservations/destroy-all-archived' => 'reservations#destroy_all_archived', as: 'destroy_all_archived_reservations'
    delete 'reservations/destroy-unconfirmed' => 'reservations#destroy_unconfirmed', as: 'destroy_unconfirmed_reservations'
    post 'reservations/destroy-reservations' => 'reservations#destroy_reservations', as: 'destroy_reservations'
    delete 'reservations/destroy-logs' => 'logs#destroy', as: 'destroy_all_logs'
    resources :donations do
      post 'send-donation-receipt' => 'donations#send_donation_receipt', as: 'send_donation_receipt'
    end
    resources :reservations, only: [ :index, :show, :edit, :update, :destroy, :archive ] do
      resources :donations
      get 'logs' => 'logs#reservation_index', as: 'logs'
      post 'process-route' => 'reservations#process_route', as: 'process_route'
      post 'process-geocode' => 'reservations#process_geocode', as: 'process_geocode'
      post 'archive' => 'reservations#archive', as: 'archive'
    end
    get '/routing' => 'zones#index', as: 'routing'
    get '/phone' => 'messages#show', as: 'phone'

    post '/marketing/send-we_are-live' => 'marketing#send_we_are_live', as: 'marketing_send_we_are_live'
    post '/marketing/send-email-1' => 'marketing#send_marketing_email_1', as: 'marketing_send_email_1'
    post '/marketing/send-email-2' => 'marketing#send_marketing_email_2', as: 'marketing_send_email_2'
    post '/send-pickup-reminders' => 'reservations#send_pickup_reminders', as: 'send_pickup_reminders'
    post '/marketing/reset-sent-campaigns' => 'marketing#reset_sent_campaigns', as: 'marketing_reset_sent_campaigns'
    get '/analytics' => 'analytics#index', as: 'analytics'

    post 'process-all-routes' => 'reservations#process_all_routes', as: 'process_all_routes'
    get 'map' => 'reservations#map', as: 'map'
    resources :routes, except: [ :index, :show ] do
      get 'map' => 'routes#map', as: 'map'
    end
    get 'search' => 'reservations#search', as: 'search'
    post 'res-upload' => 'reservations#upload', as: 'upload'
  end


  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all
end
