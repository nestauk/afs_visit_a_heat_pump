Rails.application.routes.draw do
  authenticate :user, ->(user) { user.admin? } do
    mount Blazer::Engine, at: "admin"
  end

  devise_for :users

  root "visitors#index"

  get "/hosts", to: "visitors#index", as: "hosts"
  get "/host/home", to: "hosts#home", as: "host_home"
  get "/host/past_events", to: "hosts#past_events", as: "host_past"
  get "/host/cancelled_events", to: "hosts#cancelled_events", as: "host_cancelled"

  get '/bookings/:token/cancel', to: 'bookings#review_cancellation', as: 'review_booking_cancellation'
  delete '/bookings/:token/cancel', to: 'bookings#confirm_cancellation', as: 'confirm_booking_cancellation'

  post '/hosts/:id/follow', to: 'hosts#follow', as: 'follow_host'
  # delete '/hosts/:id/unfollow/:token', to: 'hosts#unfollow', as: 'unfollow_host'

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
