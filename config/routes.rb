Rails.application.routes.draw do
    devise_for :users
    # , controllers: {
    #   sesions: 'users/sessions',
    #   registrations: 'users/registrations'
    # }
    # resources :users, only: [:index, :show]
    # get 'profile/:username', to: 'profile#show', as: 'profile'
    resources :users do
      get :search, on: :collection
    end
    # resources :profile
    # get 'profile/:id', to: 'profile#show'

    delete 'profile/unfollow', to: 'profile#unfollow'
  
  resources :profile do
      get :search, on: :collection
    end
    post 'profile/follow', to: 'profile#follow'
  resources :posts, only: %i[new index create] do
    member do
      post '/likes', to: 'likes#create'
      delete '/likes', to: 'likes#destroy'
      post '/bookmarks', to: 'bookmarks#create'
      delete '/bookmarks', to: 'bookmarks#destroy'

      resources :comments, only: [:create]
      # resources :bookmarks, only: [:create, :destroy], shallow: true
    end
  end
  root "posts#index"
end
