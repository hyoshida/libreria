Rails.application.routes.draw do
  root to: 'books#index'

  ActiveAdmin.routes(self)
  devise_for :users
  resources :books
end
