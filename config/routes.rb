Rails.application.routes.draw do
  resources :submissions, except: [:destroy, :edit, :update]
  resources :handovers, except: [:destroy]

  root 'handovers#index'

  get '/auth/:provider', to: 'authentications#passthru', as: :auth_authorize,
                         constraints: { provider: /google/ }

  get '/auth/:provider/callback', to: 'authentications#create', as: :auth_callback
  get '/auth/destroy', to: 'authentications#destroy'
  get '/auth/failure', to: 'authentications#failure'
end
