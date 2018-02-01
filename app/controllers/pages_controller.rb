class PagesController < ApplicationController
  before_action :require_login, only: [:dashboard]
  def index
  end

  def dashboard
    @sites = Site.by_user(current_user)
    @site = Site.new
    render :dashboard
  end
end
