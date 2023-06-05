Rails.application.routes.draw do
  get 'collections/index'
  get 'collections/:id', to: 'collections#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
