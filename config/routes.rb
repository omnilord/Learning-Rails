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

  get 'search/stocks' => 'stocks#search'
  get 'search/users' => 'users#search'

  get 'portfolio' => 'users#portfolio'
  get 'stocks' => 'stocks#index'

  get 'friends' => 'friendships#index'
  get 'friends/:id' => 'friendships#show'
  post 'friends/:id' => 'friendships#create'
  delete 'friends/:id' => 'friendships#destroy'

  # Catch all to prevent generic 404 errors from rendering
  get '*path', to: 'pages#badroute'
end
