Rails.application.routes.draw do
  root to: 'books#index'

  ActiveAdmin.routes(self)

  devise_for :users
  resources :organizations

  resources :namespaces, path: '/', param: :path, constraints: { path: /[-_.a-zA-Z0-9]+/ }, only: :show do
    resources :books
  end
end
