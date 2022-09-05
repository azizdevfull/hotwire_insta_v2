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
    get 'profile/:id', to: 'profile#show'

    post 'profile/follow', to: 'profile#follow'
    delete 'profile/unfollow', to: 'profile#unfollow'
  resources :profile do
      get :search, on: :collection
    end
 
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
