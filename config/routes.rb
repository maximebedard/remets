require "sidekiq/web"

Rails.application.routes.draw do
  get "home/index"

  resources :submissions, except: [:destroy, :edit, :update]
  resources :handovers, except: [:destroy]
  resources :documents, only: [:show, :index] do
    member do
      get :download
    end
  end
  resources :document_matches, only: [:show]

  root "home#index"

  get "/home", to: "dashboard#index"

  get "/auth/:provider", to: "authentications#passthru", as: :auth_authorize, constraints: { provider: /google/ }
  get "/auth/:provider/callback", to: "authentications#create", as: :auth_callback
  get "/auth/destroy", to: "authentications#destroy"
  get "/auth/failure", to: "authentications#failure"

  mount Sidekiq::Web, at: "/workers"
end
