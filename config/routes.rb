Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'user/registrations',
    devise_authy: 'user/devise_authy'
  }, path_names: {
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
  get 'search/stocks' => 'stocks#search'
  get 'stocks' => 'stocks#index'

  get 'friends' => 'users#friends'
  get 'friends/:id' => 'users#friend'
  get 'search/friends' => 'users#search'
  post 'friends' => 'users#add_friend'
  delete 'friends' => 'users#remove_friend'


  # Catch all to prevent generic 404 errors from rendering
  get '*path', to: 'pages#badroute'
end
