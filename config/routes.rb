Rails.application.routes.draw do
  namespace :v1 do
    resources :projects, only: [:index, :show] do
      resources :logs, only: [:index]
    end
  end
  
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
