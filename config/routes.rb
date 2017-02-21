Rails.application.routes.draw do
  mount StripeEvent::Engine, at: '/stripe_events'

  root to: 'static_pages#home'

  # Registration and Login

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  # Users & Accounts

  resources :users, only: [:create, :show]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :admin_invitations, only: [:edit, :update]
  get 'my_account', to: 'users#edit'
  patch 'my_account', to: 'users#update'

  # OAuth

  get '/auth/:provider/callback', to: 'services#create'
  get '/auth/failure', to: 'services#failure'

  # Subscriptions and Charges

  post 'subscribe', to: 'subscriptions#create'

  # Boards

  resources :boards do
    member do
      post 'add_member', to: 'board_memberships#create'
      delete 'remove_member', to: 'board_memberships#destroy'
    end
  end

  # API Stuff

  resources :lists, except: [:new, :edit]
  resources :cards do
    resources :checklists, except: [:new, :edit] do
      resources :check_items, except: [:new, :edit] do
        member do
          get 'toggle', to: 'check_items#toggle'
        end
      end
    end

    member do
      post 'add_comment', to: 'comments#create'
      post 'watch', to: 'card_watchings#create'
      delete 'unwatch', to: 'card_watchings#destroy'
    end
  end

  # Admin

  namespace :admin do
    resources :users, only: [:index, :new, :create, :destroy]
  end
end
