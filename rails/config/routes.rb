Rails.application.routes.draw do
  devise_for :users
  root "home_page#index"
  
  resources :collections
  resources :collection_types
  resources :items

  get '/collections/:id/collect', to: 'collections#collect', as: 'collect_collection'
  get '/collections/:id/uncollect', to: 'collections#uncollect', as: 'uncollect_collection'
  get '/collections/:id/bulk_create_items', to: 'collections#bulk_create_items', as: 'bulk_create_items'
  post '/collections/:id/bulk_create_items', to: 'collections#process_bulk_create_items', as: 'process_bulk_create_items'
  get '/items/:id/collect', to: 'items#collect'
  get '/items/:id/uncollect', to: 'items#uncollect'
  get '/admin', to: 'admin#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
