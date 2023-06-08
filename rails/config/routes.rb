Rails.application.routes.draw do
  root "collections#index"
  
  resources :collections
  resources :collection_types
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
