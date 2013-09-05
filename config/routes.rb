DCIY::Application.routes.draw do
  resources :builds

  resources :projects
  root to: "projects#index"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
