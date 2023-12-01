Rails.application.routes.draw do
  devise_for :users

  # TODO: limit routes
  resources :hosts do
    resources :events do
      resources :bookings
    end
  end

  root "hosts#home"
end
