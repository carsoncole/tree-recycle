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

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  get '/about' => 'home#about', as: 'about'
  get '/questions' => 'home#questions', as: 'questions'

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
    resources :routes, only: %i( show )
    resources :drivers, only: %i( index show )
    get '/routing' => 'zones#index', as: 'routing'
    get '/zones' => 'zones#index', as: 'zones'
  end

  namespace :admin do
    root 'reservations#index'
    resources :zones
    resources :drivers
    resources :messages, only: [:index, :create, :destroy ]
    resources :donations, only: [ :index, :show ]
    resources :settings, only: [ :index, :edit, :update ]
    resources :users, only: [ :index, :update, :create, :destroy, :edit ]
    resources :driver_routes, only: [:create, :destroy]
    resources :points, only: [:create, :update, :destroy, :edit]
    delete 'reservations/archive-all' => 'reservations#archive_all_unarchived', as: 'archive_all_unarchived_reservations'
    delete 'reservations/destroy-all' => 'reservations#destroy_all', as: 'destroy_all_reservations'
    delete 'reservations/destroy-all-archived' => 'reservations#destroy_all_archived', as: 'destroy_all_archived_reservations'
    delete 'reservations/destroy-unconfirmed' => 'reservations#destroy_unconfirmed', as: 'destroy_unconfirmed_reservations'
    post 'reservations/destroy-reservations' => 'reservations#destroy_reservations', as: 'destroy_reservations'
    post 'reservations/merge-unarchived' => 'reservations#merge_unarchived', as: 'merge_unarchived_reservations'
    resources :reservations, only: [ :index, :show, :edit, :update, :destroy, :archive ] do
      get 'logs' => 'logs#index', as: 'logs'
      post 'process-route' => 'reservations#process_route', as: 'process_route'
      post 'process-geocode' => 'reservations#process_geocode', as: 'process_geocode'
      post 'archive' => 'reservations#archive', as: 'archive'
    end
    get '/routing' => 'zones#index', as: 'routing'


    post '/marketing/send-email-1' => 'marketing#send_marketing_email_1', as: 'marketing_send_email_1'
    post '/marketing/send-email-2' => 'marketing#send_marketing_email_2', as: 'marketing_send_email_2'
    post '/marketing/reset-sent-campaigns' => 'marketing#reset_sent_campaigns', as: 'marketing_reset_sent_campaigns'
    get '/marketing' => 'marketing#index', as: 'marketing'

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
