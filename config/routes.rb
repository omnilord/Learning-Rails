Rails.application.routes.draw do
  devise_for :users

  # Static pages
  root 'pages#index'
  get 'careers' => 'pages#careers'
  get 'about' => 'pages#about'


  #all route should go here


  # Catch all to prevent generic 404 errors from rendering
  get '*path', to: 'pages#badroute'
end
