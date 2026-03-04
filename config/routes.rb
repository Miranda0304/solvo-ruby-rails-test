Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do

      # USERS
      resources :users, only: %i[index show create]

      # ROOMS
      resources :rooms, only: %i[index show create] do
        member do
          get :availability
        end
      end

      # RESERVATIONS
      resources :reservations, only: %i[index show create destroy] do
        member do
          patch :cancel
        end
      end
    end
  end
end
