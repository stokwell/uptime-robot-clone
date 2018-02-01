class SitesController < ApplicationController

  def create
    @site = Site.create(site_params.merge(user_id: current_user.id))
  end

  private

  def site_params
    params.require(:site).permit(:title, :url, :frequency, :up, :enabled)
  end

end
