Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users do
    collection do
      post 'login'
    end
  end
  resources :users
  resources :kittens
end
