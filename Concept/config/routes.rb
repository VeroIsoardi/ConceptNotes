Rails.application.routes.draw do
  root 'statics#index'
  get 'register' => 'users#new', :as => 'register'
  get 'login' => 'sessions#new', :as => :login
  post 'logout' => 'sessions#destroy', :as => :logout
  resources :users
  resources :sessions
  resources :statics
end
