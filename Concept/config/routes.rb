Rails.application.routes.draw do
  resources :notes
  resources :books
  resources :users
  resources :sessions
  root 'previews#index'
  get 'index' => 'statics#index', :as => :home
end
