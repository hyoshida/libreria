Rails.application.routes.draw do
  root to: 'books#index'

  ActiveAdmin.routes(self)

  devise_for :users
  resources :users, param: :path, only: [:index, :show]

  resources :organizations, param: :path do
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
    resources :books do
      member do
        put '/wish', action: :wish
        patch '/wish', action: :wish
        put '/loan', action: :loan
        patch '/loan', action: :loan
        put '/return', action: :return
        patch '/return', action: :return
      end
    end
  end
end
