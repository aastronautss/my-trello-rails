Rails.application.routes.draw do
  root to: 'static_pages#home'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: [:create]

  resources :boards
  resources :lists, except: [:index, :show]
  resources :cards, except: [:index] do
    resources :comments
  end
end
