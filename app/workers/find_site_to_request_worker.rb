class FindSiteToRequestWorker
  include Sidekiq::Worker

  def perform(*args)
    sites = Site.all
    sites.each do |site|
      if site.enabled
        UriResponseWorker.perform_async(site.id)
      end
    end
  end

end
