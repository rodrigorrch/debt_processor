require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :debts, only: [] do
        collection do
          post :upload
          get "status/:id", to: "debts#status", as: :status
        end
      end
    end
  end
end
