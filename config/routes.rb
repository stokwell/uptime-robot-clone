require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'

  get '/dashboard', to: 'pages#dashboard'

  get 'sites/start_monitoring', to: 'sites#start_monitoring', as: :start_monitoring
  get 'sites/stop_monitoring', to: 'sites#stop_monitoring', as: :stop_monitoring 

  resource :sites do
    collection do
      get 'start_monitoring'
    end
  end

  mount Sidekiq::Web, at: '/sidekiq'

  resource  :session,
    :controller => 'sessions',
    :only => [:new, :create, :destroy]
end
