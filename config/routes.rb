Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
    root "static_pages#home"

    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: "logout"
    get "/search", to: "documents#search", as: "search"

    namespace :admin do
      resources :documents, only: %i(index edit update)
      resources :users, only: %i(index edit update)
      resources :categories, only: %i(index edit update new create)
      resources :histories, only: :index
    end

    resources :documents do
      resources :comments, only: %i(new create delete)
    end
    resources :comments do
      resources :comments, only: %i(new create delete)
    end
    resources :users, only: %i(show new create) do
      member do
        get :favorites
      end
    end
    resources :downloads, only: :show
    resources :categories, only: %i(new create)
    resources :favorites, only: %i(create destroy)
    resources :account_activations, only: :edit
  end
end
