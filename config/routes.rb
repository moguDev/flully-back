Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      }

      resources :walks, only: %i[index show destroy] do
        get 'in_progress', on: :collection
        collection do
          post :start
          post :finish
        end
      end

      get 'users/:name', to: 'users#show'
      get 'myprofile', to: 'users#show_myprofile'
      get 'users/check_name', to: 'users#check_name'

      resources :checkpoints, only: [:create]

      resources :posts, only: [:index, :show, :create, :destroy]

      resources :post_comments, only: [:index, :create]

      resources :boards, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get :nearby_boards
          get :search
        end
      end

      post "posts/:id/likes", to: "likes#create"
      delete "posts/:id/likes", to: "likes#destroy"
      get "posts/:id/is_user_liked", to: "posts#is_user_liked"

      post "boards/:id/bookmarks", to: "bookmarks#create"
      delete "boards/:id/bookmarks", to: "bookmarks#destroy"
      get "boards/:id/is_user_bookmarked", to: "boards#is_user_bookmarked"

      resources :board_comments, only: [:create, :index]
    end
  end
end