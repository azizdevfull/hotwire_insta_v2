Rails.application.routes.draw do
    devise_for :users
    # , controllers: {
    #   sesions: 'users/sessions',
    #   registrations: 'users/registrations'
    # }
    # resources :users, only: [:index, :show]
    resources :users, only: [:show]

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
