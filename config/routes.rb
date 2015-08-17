Rails.application.routes.draw do
  resources :submissions, only: [:show, :new, :create]
end
