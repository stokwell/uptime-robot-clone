require 'timeout'

class UriResponseWorker
  include Sidekiq::Worker

  def perform(site_id)
      if site = Site.find_by(id: site_id)
      uri = URI.parse(site.url)
      frequency = site.frequency
      begin
        response_code = Timeout::timeout(5) { Net::HTTP.get_response(uri).code }
        logger.info "Response: #{site_id} - #{response_code} - #{site.url}"
        case response_code&.chars&.first
        when '2'
          good_response(site, response_code)
        when '3'
          good_response(site, response_code)
        else
          bad_response(site, response_code)
        end
      rescue Timeout::Error
        bad_response(site, 'Timeout')
      rescue Errno::ECONNREFUSED
        bad_response(site, 'Connection Refused')
      end
    end
  end

  def good_response(site, response_code)
    unless site.up?
      logger.info "Site was bad: #{site.id} - #{response_code} - #{site.url}"
      site.update_attribute(:up, true)
    end
    UriResponseWorker.perform_in(site.frequency, site.id)
  end

  def bad_response(site, response_code)
    if site.up?
      logger.info "Site was good: #{site.id} - #{response_code} - #{site.url}, but failed!!!"
      site.update_attribute(:up, false)
    else
      logger.info "#{site.url} has responsed with '#{response_code}'."
    end
  end
end
