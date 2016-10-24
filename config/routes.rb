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
  get 'portfolio' => 'users#portfolio'


  # Catch all to prevent 404 errors from rendering a sad face page
  get '*path', to: 'pages#index'
end
