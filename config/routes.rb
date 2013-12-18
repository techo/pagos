Pagos::Application.routes.draw do

  devise_for :users
  root to: "home#index"

  get 'users', to: 'users#edit'
  post 'update_users', to: 'users#update'

  resources :payments, only: [ :new, :create ]
end
