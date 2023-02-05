Rails.application.routes.draw do
  root 'components#index'
  namespace :api do
    namespace :v1 do
      resources :questions, only: [:create]
    end
  end
end
