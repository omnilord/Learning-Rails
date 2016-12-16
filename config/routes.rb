Rails.application.routes.draw do
  devise_for :users, path_names: {
    verify_authy: '/vtoken',
    enable_authy: '/enable_2fa',
    verify_authy_installation: '/vauth'
  }

  # Static pages
  root 'pages#index'
  get 'careers' => 'pages#careers'
  get 'about' => 'pages#about'


  # Resources
  resources :user_stocks, except: [:edit, :show]

  get 'portfolio' => 'users#portfolio'
  get 'search' => 'stocks#search'
  #get 'stock/:ticker' => 'stocks#stock'
  get 'stocks' => 'stocks#index'

  # Catch all to prevent generic 404 errors from rendering
  get '*path', to: 'pages#badroute'
end
