Rails.application.routes.draw do
  root 'home#index'

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
