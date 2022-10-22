Rails.application.routes.draw do
  root 'home#index'

  get '/about' => 'about#index', as: 'about'

  resources :reservations, except: [:index] do
    get 'form-1', as: 'form_1'
    get 'form-2', as: 'form_2'
  end

  resources :settings, only: [:index]

  namespace :admin do
    resources :reservations, only: [ :index, :show, :edit, :update ]
    get 'map' => 'reservations#map', as: 'map'
  end

end
