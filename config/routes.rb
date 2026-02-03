Rails.application.routes.draw do
  # Authentication (existing)
  resource :session
  resources :passwords, param: :token

  # Main application
  root "dashboard#index"

  resources :clients, only: [ :new, :create, :show, :edit, :update ] do
    resources :purchases, only: [ :create ] do
      collection do
        post :claim_reward
      end
    end
  end

  resources :settings, only: [ :index, :update ], param: :key

  # Health check (existing)
  get "up" => "rails/health#show", as: :rails_health_check
end
