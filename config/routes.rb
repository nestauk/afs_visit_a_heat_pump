Rails.application.routes.draw do
  devise_for :users

  resources :hosts

  root "hosts#home"
end
