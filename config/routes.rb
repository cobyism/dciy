Dciy::Application.routes.draw do
  resources :builds

  resources :projects
  root to: "projects#index"
end
