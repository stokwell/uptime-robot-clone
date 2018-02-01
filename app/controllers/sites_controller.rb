class SitesController < ApplicationController

  def create
    @site = Site.create(site_params.merge(user_id: current_user.id))
    UriResponseWorker.perform_in(2.seconds, @site.id, @site.url)
  end

  def start_monitoring()
  end

  def minutes_to_seconds
  end

  private

  def site_params
    params.require(:site).permit(:title, :url, :frequency, :up, :enabled)
  end

end
