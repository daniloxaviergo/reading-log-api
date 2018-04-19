Rails.application.routes.draw do
  namespace :v1 do
    resources :projects, only: [:index, :show] do
      resources :logs, only: :index
    end

    namespace :dashboard do
      resources :day,       only: :index
      resources :projects,  only: :index
      resources :last_days, only: :index

      namespace :echart do
        resources :speculate_actual, only: :index
        resources :faults_week_day,  only: :index
        resources :day_week,         only: :index
        resources :faults,           only: :index
        resources :total,            only: :index
      end
    end
  end

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
