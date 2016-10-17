Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'

  # Static pages
  get 'careers' => 'pages#careers'
  get 'about' => 'pages#about'


  # Resources


  # Catch all to prevent 404 errors from rendering a sad face page
  get '*path', to: 'pages#index'
end
