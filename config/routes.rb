Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :twilio_notifications, only: [:create]
      resources :instant_messagings, only: [:create]
    end
  end

  get '/hola', to: 'example#index'
  get '/error', to: ->(_) { raise "upsi" }
end
