Rails.application.routes.draw do
  devise_for :users

  resources :hosts do
    resources :events
  end

  root "hosts#home"
end
