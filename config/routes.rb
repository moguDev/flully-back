Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      resources :walks, only: %i[create update destroy] do
        get 'in_progress', on: :collection
        collection do
          post :start
          post :finish
        end
      end

      get 'users/:name', to: 'users#show'
      get 'users/check_name', to: 'users#check_name'

      resources :checkpoints, only: [:create]

      resources :posts, only: [:create] do
        collection do
          get :nearby_posts
        end
      end
    end
  end
end
