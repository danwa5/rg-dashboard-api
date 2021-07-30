Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#authenticate'

  namespace :api do
    namespace :v1 do
      resources :quotes, only: [:show]
      resources :watchlists, only: [:index, :show, :create, :destroy]
    end
  end
end
