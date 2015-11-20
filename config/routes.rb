require 'sidekiq/web'

Rails.application.routes.draw do
  resources :submissions, except: [:destroy, :edit, :update]
  resources :handovers, except: [:destroy]
  resources :documents, only: [:show] do
    collection do
      match ':id.:extension', to: 'documents#download', via: [:get], as: :download
    end
  end

  root 'handovers#index'

  get '/auth/:provider', to: 'authentications#passthru', as: :auth_authorize, constraints: { provider: /google/ }
  get '/auth/:provider/callback', to: 'authentications#create', as: :auth_callback
  get '/auth/destroy', to: 'authentications#destroy'
  get '/auth/failure', to: 'authentications#failure'

  mount Sidekiq::Web, at: '/workers'
end
