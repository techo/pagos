Pagos::Application.routes.draw do

  devise_for :users
  root to: "home#index"

  get 'users', to: 'users#edit'
  get 'volunteers', to: 'users#volunteers'
  post 'update_users', to: 'users#update'

  resources :payments, only: [ :index, :create ]
  resources :geographies, only: [ :index ]
  resources :assignments, only: [ :new, :create, :show ]
  resources :reports, only: [ :new, :create ]
end
