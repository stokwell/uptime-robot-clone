class FindSiteToRequestWorker
  include Sidekiq::Worker

  def perform
    sites = Site.find_each do |site|
      if site.enabled
        UriResponseWorker.perform_async(site.id)
      end
    end
  end
end
