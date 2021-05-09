Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :quotes, only: [:show]
      resources :watchlists, only: [:index, :show]
    end
  end
end
