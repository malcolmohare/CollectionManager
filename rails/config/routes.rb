Rails.application.routes.draw do
  devise_for :users
  root "home_page#index"
  
  resources :collections
  resources :collection_types
  resources :collection_items

  get '/collections/:id/collect', to: 'collections#collect'
  get '/collections/:id/uncollect', to: 'collections#uncollect'
  get '/collection_items/:id/collect', to: 'collection_items#collect'
  get '/collection_items/:id/uncollect', to: 'collection_items#uncollect'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
