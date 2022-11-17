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

  post 'res-upload' => 'reservations#upload', as: 'upload'

  resources :reservations, except: [:index] do

    get 'address-verification', as: 'address_verification'

    resources :donations, only: %i[ new create ]
    post 'cash-or-check' => 'donations#cash_or_check', as: 'cash_or_check'
    get 'donations/success' => 'donations#success', as: 'success'
    get 'donations/cancel' => 'donations#cancel', as: 'cancel'
    post 'stripe-webhook' => "charges#stripe_webhook"


    post 'submit-reservation' => 'reservations#submit_reservation', as: 'submit'

    # resources :charges, only: %i[ new create ]

  end

  post 'stripe-webhook' => "donations#stripe_webhook"

  namespace :driver do
    get 'reservations/search' => 'reservations#search', as: 'reservations_search'
    get 'reservations/map' => 'reservations#map', as: 'reservations_map'

    root 'zones#index'
    resources :reservations, only: %i( update )
    resources :routes, only: %i( index show )
    resources :zones, only: %i( index show )
    resources :drivers, only: %i( index show )
    get 'home' => 'home#index', as: 'home'
    get '/routing' => 'zones#index', as: 'routing'
  end


  namespace :admin do
    root 'home#index'
    get 'home' => 'home#index', as: 'home'
    resources :zones
    resources :drivers
    resources :donations, only: [ :index, :show ]
    resources :settings, only: [ :index, :edit, :update ]
    resources :reservations, only: [ :index, :show, :edit, :update, :destroy ] do
      get 'logs' => 'logs#index', as: 'logs'
      post 'process-route' => 'reservations#process_route', as: 'process_route'
    end
    get '/routing' => 'zones#index', as: 'routing'

    delete 'admin/home/archive-all' => 'home#archive_all', as: 'archive_all'

    post 'process-all-routes' => 'reservations#process_all_routes', as: 'process_all_routes'
    get 'map' => 'reservations#map', as: 'map'
    resources :routes do
      get 'map' => 'routes#map', as: 'map'
    end
    get 'search' => 'reservations#search', as: 'search'
  end

end
