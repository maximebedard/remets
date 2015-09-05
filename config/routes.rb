Rails.application.routes.draw do
  resources :submissions, except: [:destroy, :edit, :update]
  resources :handovers, except: [:destroy]

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/destroy', to: 'authentications#destroy'
  get '/auth/failure', to: 'authentications#failure'
end
