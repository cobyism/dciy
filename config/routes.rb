DCIY::Application.routes.draw do
  resources :builds

  resources :projects do
    resources :builds, :except => [:edit, :update]
  end
  root to: "builds#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
