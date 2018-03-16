Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "kittens#index"
  resources :users do
    collection do
      post 'login'
      delete 'logout'
    end
  end
  resources :users
  resources :kittens
end
