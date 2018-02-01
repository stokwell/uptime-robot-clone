require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'

  get '/dashboard', to: 'pages#dashboard'

  resource :sites

  mount Sidekiq::Web, at: '/sidekiq'

  resource  :session,
    :controller => 'sessions',
    :only => [:new, :create, :destroy]
end
