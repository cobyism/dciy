DCIY::Application.routes.draw do
  resources :builds

  resources :projects do
    resources :builds
  end
  root to: "builds#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
