Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        # sessions: 'api/v1/auth/sessions',
        registrations: 'api/v1/auth/registrations',
        token_validations: 'api/v1/auth/token_validations',
        passwords: 'api/v1/auth/passwords',
        omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      }

      get 'users/:name', to: 'users#show'
      get 'myprofile', to: 'users#show_myprofile'
      get 'users/check_name', to: 'users#check_name'
      get 'users/:name/followings', to: "users#followings"
      get 'users/:name/followers', to: "users#followers"

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

      resources :follows, only: [:create, :destroy] do
        get :check_status, on: :collection
      end

      resources :timeline, only: [:index]

      resources :notifications, only: [:index] do
        collection do
          get :unread
          post :checked
        end
      end
    end
  end
end