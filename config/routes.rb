Rails.application.routes.draw do
  resources :submissions, except: [:destroy, :edit, :update]
end
