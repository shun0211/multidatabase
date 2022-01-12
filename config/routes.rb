Rails.application.routes.draw do
  root to: 'articles#index'
  devise_for :users
  resources :articles
  get 'photos', to: 'images#index'
  get 'photos', to: 'photos#index'
end
