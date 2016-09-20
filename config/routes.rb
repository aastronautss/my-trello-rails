Rails.application.routes.draw do
  root to: 'static_pages#home'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: [:create]

  resources :boards do
    member do
      get 'add_member', to: 'board_memberships#new'
      post 'add_member', to: 'board_memberships#create'
    end
  end
  resources :lists, except: [:show, :new]
  resources :cards
  resources :comments, except: [:show, :new]
end
