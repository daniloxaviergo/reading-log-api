Rails.application.routes.draw do
  # dashboard/day
  # dashboard/echart/speculate_efective
  # dashboard/last_days?count=7|15
  # projects.json?filter={ status = not_fineshed }
  # dashboard/echart/day_week?day=1
  # dashboard/echart/total

  namespace :v1 do
    resources :projects, only: [:index, :show] do
      resources :logs, only: :index
    end

    namespace :dashboard do
      resources :day,       only: :index
      resources :last_days, only: :index

      namespace :echart do
        resources :speculate_efective, only: :index
        resources :day_week,           only: :index
        resources :total,              only: :index
      end
    end
  end

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
