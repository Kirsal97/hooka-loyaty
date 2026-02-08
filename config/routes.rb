Rails.application.routes.draw do
  # Authentication (existing)
  resource :session
  resources :passwords, param: :token

  # Locale switching
  patch "locale", to: "locale#update"

  # Main application
  root "dashboard#index"

  resources :clients, only: [ :new, :create, :show, :edit, :update ] do
    resources :purchases, only: [ :create, :destroy ] do
      collection do
        post :claim_reward
      end
    end
  end

  resources :settings, only: [ :index, :update ], param: :key

  namespace :admin do
    resources :purchases, only: [:index]
  end

  # Health check (existing)
  get "up" => "rails/health#show", as: :rails_health_check
end
