Rails.application.routes.draw do

  root 'games#index'
  resources :games
  resources :orders, only: [:create, :destroy]

end
