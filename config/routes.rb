Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "kittens#index"
  resources :users do
    collection do
      post 'login'
      delete 'logout'
    end
  end

  resources :kittens do
    member do
      put 'like', to: "kittens#upvote"
      put 'dislike', to: "kittens#downvote"
      get "likers"
    end
  end


  resources :users
  resources :kittens
end
