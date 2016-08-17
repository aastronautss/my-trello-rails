Rails.application.routes.draw do
  root to: 'static_pages#home'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: [:create]

  resources :boards
  resources :lists, except: [:show]
  resources :cards, except: [:index] do
    resources :comments
  end

  resources :board_memberships, only: [:new, :create]
end
