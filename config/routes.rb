Rails.application.routes.draw do
  root to: 'books#index'

  ActiveAdmin.routes(self)

  devise_for :users
  resources :users, only: :index

  resources :organizations do
    resources :members, only: [:index, :new, :create, :destroy] do
      collection do
        put '/', action: :update
        patch '/', action: :update
        get '/request', action: :requests
        post '/request', action: :requests_complete
        get '/accept', action: :accept
      end
    end
  end

  resources :namespaces, path: '/', param: :path, constraints: { path: /[-_.a-zA-Z0-9]+/ }, only: :show do
    resources :books
  end
end
