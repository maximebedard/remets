require "sidekiq/web"

Rails.application.routes.draw do
  resources :handovers, only: [:index, :show, :new, :create, :edit, :update], param: :uuid do
    resources :submissions, only: [:index, :show, :new, :create], shallow: true
  end
  get "/submissions", as: :submissions, to: "submissions#all"
  resources :documents, only: [:index, :show] do
    member do
      get :download
    end
  end
  resources :document_matches, only: [:show]
  resources :users, only: [:create]

  resource :registration, only: [:new, :create]
  resource :account, only: [:show, :edit, :update] do
    resources :organizations, only: [:index, :show, :edit, :update, :new, :create]
  end

  root "home#index"

  scope :auth, controller: :authentications, as: :auth do
    oauth_constraints = { constraints: { provider: /google/ } }
    get "/new", action: "new"
    get "/", to: redirect("/auth/new"), as: :index
    post "/", action: "create"
    match "/destroy", action: "destroy", via: [:get, :delete]
    get "/:provider", action: "passthru", as: :authorize, **oauth_constraints
    get "/:provider/callback", action: "callback", as: :callback, **oauth_constraints
    get "/failure", action: "failure"
  end

  mount Sidekiq::Web, at: "/workers"
end
