Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: "logout"
    get "/search", to: "documents#search", as: "search"

    resources :documents, only: %i(create show)
    resources :users, only: :show
    resources :downloads, only: :show
  end
end
