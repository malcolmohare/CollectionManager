Rails.application.routes.draw do
  devise_for :users
  root "home_page#index"
  
  resources :collections
  resources :collection_types
  resources :collection_items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
