Rails.application.routes.draw do
  devise_for :users

  root "visitors#search"

  get "/hosts", to: "visitors#index", as: "hosts"
  get "/home", to: "hosts#home", as: "host_home"

  # TODO: limit routes
  resources :hosts, except: :index do
    resources :events do
      resources :bookings
    end
  end
end
