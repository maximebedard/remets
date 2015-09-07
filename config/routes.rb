Rails.application.routes.draw do
  resources :submissions, except: [:destroy, :edit, :update]
  resources :handovers, except: [:destroy]

  root 'handovers#index'

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/destroy', to: 'authentications#destroy'
  get '/auth/failure', to: 'authentications#failure'
end
