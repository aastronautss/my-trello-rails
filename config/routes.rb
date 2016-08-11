Rails.application.routes.draw do
  root to: 'static_pages#home'

  resources :boards
  resources :lists, except: [:index, :show]
  resources :cards, except: [:index] do
    resources :comments
  end
end
