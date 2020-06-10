Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: "logout"
    get "/search", to: "documents#search", as: "search"

    namespace :admin do
      resources :documents, only: %i(index edit update)
    end

    resources :documents, only: %i(create show) do
        resources :comments, only: %i(new create)
    end
    resources :comments do
      resources :comments, only: %i(new create)
    end
    resources :users, only: :show
    resources :downloads, only: :show
  end
end
