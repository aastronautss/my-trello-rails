Rails.application.routes.draw do
  root to: 'static_pages#home'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: [:create, :show]
  resources :account_activations, only: [:edit]

  resources :boards do
    member do
      post 'add_member', to: 'board_memberships#create'
      delete 'remove_member', to: 'board_memberships#destroy'
    end
  end

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
    end
  end
end
