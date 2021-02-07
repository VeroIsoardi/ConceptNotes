Rails.application.routes.draw do
  resources :notes
  resources :books
  resources :users
  resources :sessions
  resources :statics
  resources :previews
  root 'previews#index'
  get 'index' => 'statics#index', :as => :home
  get 'register' => 'users#new', :as => :register
  get 'login' => 'sessions#new', :as => :login
  post 'logout' => 'sessions#destroy', :as => :logout  
end
