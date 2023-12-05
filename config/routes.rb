Rails.application.routes.draw do
  devise_for :users

  root "visitors#search"

  get "/hosts", to: "visitors#index", as: "hosts"
  get "/host/home", to: "hosts#home", as: "host_home"
  get "/host/past_events", to: "hosts#past_events", as: "host_past"
  get "/host/cancelled_events", to: "hosts#cancelled_events", as: "host_cancelled"

  # TODO: limit routes
  resources :hosts, except: :index do
    resources :events do
      member do
        delete :cancel
      end
      resources :bookings
    end
  end
end
