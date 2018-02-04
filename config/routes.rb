require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'

  get '/dashboard', to: 'pages#dashboard'

  resource :sites do
    collection do
      get 'enable_monitoring'
      get 'disable_monitoring'
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'

  resource  :session,
    :controller => 'sessions',
    :only => [:new, :create, :destroy]
end
