class SitesController < ApplicationController

  def create
    site = Site.create(site_params.merge(user_id: current_user.id))
    UriResponseWorker.perform_async(site.id)
    redirect_to controller: 'pages', action: 'dashboard'
  end

  def destroy
    site = Site.find(params[:format])
    site.destroy
    redirect_to controller: 'pages', action: 'dashboard'
  end

  def enable_monitoring
    site = Site.find_by(id: params[:format])
    UriResponseWorker.perform_async(site.id)
    site.update_attributes(enabled: true)

    redirect_to controller: 'pages', action: 'dashboard'
  end

  def disable_monitoring
    site = Site.find_by(id: params[:format])
    site.update_attributes(enabled: false, up: nil)
    redirect_to controller: 'pages', action: 'dashboard'
  end

  private

  def site_params
    params.require(:site).permit(:title, :url, :frequency, :up, :enabled)
  end

end
