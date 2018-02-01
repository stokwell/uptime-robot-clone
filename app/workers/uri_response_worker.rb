require 'timeout'

class UriResponseWorker
  include Sidekiq::Worker

  def perform(id, url)
    if site = Site.find_by(id: id)
      uri = URI.parse(url)
      begin
        response_code = Timeout::timeout(5) { Net::HTTP.get_response(uri).code }
        logger.info "Response: #{id} - #{response_code} - #{url}"
        case response_code&.chars&.first
        when '2'
          good_response(site, response_code, id, url)
        when '3'
          good_response(site, response_code, id, url)
        else
          bad_response(site, response_code, id, url)
        end
      rescue Timeout::Error
        bad_response(site, 'Timeout', id, url)
      rescue Errno::ECONNREFUSED
        bad_response(site, 'Connection Refused', id, url)
      end
    end
  end

  def good_response(site, response_code, id, url)
    unless site.up?
      logger.info "Site was bad: #{id} - #{response_code} - #{url}"
      site.update_attribute(:up, true)
    end
    UriResponseWorker.perform_in(60.seconds, id, url)
  end

  def bad_response(site, response_code, id,  url)
    if site.up?
      logger.info "Site was good: #{id} - #{response_code} - #{url}"
      site.update_attribute(:up, false)
    end
    UriResponseWorker.perform_in(30.seconds, id, url)
  end
end
