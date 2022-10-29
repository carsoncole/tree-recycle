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

  get '/about' => 'about#index', as: 'about'
  get '/questions' => 'home#questions', as: 'questions'

  get '/donation' => 'donations#donation_without_reservation', as: 'donation_without_reservation'
  get '/thank-you-for-your-donation' => 'success#donations', as: 'success'

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

  namespace :admin do
    resources :settings, only: [ :index, :edit, :update ]
    resources :reservations, only: [ :index, :show, :edit, :update ] do
      post 'process-zone' => 'reservations#process_zone', as: 'process_zone'
    end

    post 'process-all-zones' => 'reservations#process_all_zones', as: 'process_all_zones'

    resources :zones
    get 'search' => 'reservations#search', as: 'search'
  end

end
