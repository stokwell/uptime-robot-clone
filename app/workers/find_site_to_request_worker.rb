class FindSiteToRequestWorker
  include Sidekiq::Worker

  def perform
    sites = Site.find_each do |site|
      if site.enabled && Time.now - site.checked_at > site.frequency.minutes
        UriResponseWorker.perform_async(site.id)
      end
    end
  end
end
