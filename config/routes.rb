Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'songs#index'

  resources :songs, only: [:index, :create] do
    collection do
      get 'mode'
      get 'search'
      post 'upload'
    end
    member do
      get 'next'
    end
  end

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
