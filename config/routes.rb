Rails.application.routes.draw do

  root 'home#index'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  get '/about' => 'home#about', as: 'about'
  get '/questions' => 'home#questions', as: 'questions'

  get '/donation' => 'donations#donation_without_reservation', as: 'donation_without_reservation'
  get '/thank-you-for-your-donation' => 'donations#success', as: 'success'

  resources :reservations, except: [:index] do

    get 'address-verification', as: 'address_verification'

    resources :donations, only: %i[ new create ]
    post 'cash-or-check' => 'donations#cash_or_check', as: 'cash_or_check'
    get 'donations/success' => 'donations#success', as: 'success'
    get 'donations/cancel' => 'donations#cancel', as: 'cancel'


    post 'submit-reservation' => 'reservations#submit_confirmed_reservation', as: 'submit'


  end

  post 'stripe-webhook' => "donations#stripe_webhook"

  namespace :driver do
    root 'zones#index'
    get 'contact' => 'contact#index', as: 'contacts'
    get 'reservations/map' => 'reservations#map', as: 'reservations_map'
    get 'search' => 'reservations#search', as: 'search'
    resources :reservations, only: %i( update show ) do
      get 'map' => 'reservations#map', as: 'map'
    end
    resources :routes, only: %i( show )
    resources :drivers, only: %i( index show )
    get '/routing' => 'zones#index', as: 'routing'
    get '/zones' => 'zones#index', as: 'zones'
  end

  namespace :admin do
    root 'zones#index'
    resources :zones, except: [ :show ]
    resources :drivers
    resources :donations, only: [ :index, :show ]
    resources :settings, only: [ :index, :edit, :update ]
    delete 'reservations/archive-all' => 'reservations#archive_all', as: 'archive_all'
    resources :reservations, only: [ :index, :show, :edit, :update, :destroy ] do
      get 'logs' => 'logs#index', as: 'logs'
      post 'process-route' => 'reservations#process_route', as: 'process_route'
      post 'process-geocode' => 'reservations#process_geocode', as: 'process_geocode'
    end
    get '/routing' => 'zones#index', as: 'routing'
    post 'process-all-routes' => 'reservations#process_all_routes', as: 'process_all_routes'
    get 'map' => 'reservations#map', as: 'map'
    resources :routes, except: [ :index ] do
      get 'map' => 'routes#map', as: 'map'
    end
    get 'search' => 'reservations#search', as: 'search'
    post 'res-upload' => 'reservations#upload', as: 'upload'
  end

end
