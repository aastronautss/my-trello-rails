Rails.application.routes.draw do
  root to: 'static_pages#home'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: [:create]

  resources :boards do
    member do
      post 'add_member', to: 'board_memberships#create'
      delete 'remove_member', to: 'board_memberships#destroy'
    end
  end
  resources :lists, except: [:show, :new]
  resources :cards
  resources :comments, except: [:show, :new]
end
