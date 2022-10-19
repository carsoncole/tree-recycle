Rails.application.routes.draw do
  root 'home#index'

  get '/about' => 'about#index', as: 'about'

  resources :reservations
  resources :settings, only: :index
end
