Rails.application.routes.draw do
  resources :notes
  resources :books
  resources :users
  resources :sessions
  root 'previews#index'
  get 'index' => 'statics#index', :as => :home
  get 'export' => 'previews#export', :as => :export
  get '/notes/:id/export' => 'notes#export', :as => :export_note
  get '/books/:id/export' => 'books#export', :as => :export_book
end
