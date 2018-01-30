class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    redirect to "pages#dashboard"
  end
end
