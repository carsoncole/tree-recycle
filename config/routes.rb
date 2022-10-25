Rails.application.routes.draw do
  root 'home#index'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"

  get '/about' => 'about#index', as: 'about'

  resources :reservations, except: [:index] do
    get 'form-1', as: 'form_1'
    get 'form-2', as: 'form_2'

    post 'submit-reservation' => 'reservations#submit_reservation', as: 'submit'
    resources :charges
  end

  namespace :admin do
    resources :settings, only: [ :index, :edit, :update ]
    resources :reservations, only: [ :index, :show, :edit, :update ]
    resources :zones
  end

end
