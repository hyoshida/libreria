Rails.application.routes.draw do
  root to: 'books#index'

  ActiveAdmin.routes(self)

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, param: :path, constraints: { path: Namespace.path_regexp }, only: [:index, :show]

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

  resources :namespaces, path: '/', param: :path, constraints: { path: Namespace.path_regexp }, only: :show do
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
