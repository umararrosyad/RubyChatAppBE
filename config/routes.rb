Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  mount ActionCable.server => '/cable'
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index]
      resources :messages, only: [:create]
      resources :rooms, only: [:create, :index, :show] do
        post :join, on: :member
        get :messages, on: :member
        get :users, on: :member
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
