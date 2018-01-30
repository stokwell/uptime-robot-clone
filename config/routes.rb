Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'

  get '/dashboard', to: 'pages#dashboard'

  constraints Clearance::Constraints::SignedIn.new do
    root to: 'pages#dashboard', as: :signed_in_root
  end
end
