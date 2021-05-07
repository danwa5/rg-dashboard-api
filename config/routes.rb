Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :quotes, only: [:show]
    end
  end
end
