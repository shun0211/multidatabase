Rails.application.routes.draw do
  get :health_check, to: 'health_check#health_check'
  root to: 'articles#index'
  devise_for :users
  resources :articles
  get 'photos', to: 'images#index'
  get 'photos', to: 'photos#index'
end
