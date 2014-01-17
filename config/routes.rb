DCIY::Application.routes.draw do
  resources :builds

  resources :projects, :except => [:index] do
    resources :builds, :except => [:edit, :update]
  end

  post "webhooks/receive"

  root to: "builds#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
