Rails.application.routes.draw do
 root to: 'tasks#index'
 
 get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create]

  
end
