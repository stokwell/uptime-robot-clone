class UriResponseWorker
  include Sidekiq::Worker
  include Typhoeus

  def perform(site_id)
    @site = Site.find_by(id: site_id)
    request = Typhoeus::Request.new(@site.url, timeout: 5)

    #The callbacks should be defined before running the request.
    request.on_complete do |response|
      if response.success?
        logger.info("HTTP request successed: " + response.code.to_s)
        good_response
      elsif response.timed_out?
        logger.info("HTTP request got a time out")
      elsif response.code == 0
        # Could not get an http response, something's wrong.
        logger.info(response.return_message)
        bad_response
      else
        # Received a non-successful http response.
        logger.info("HTTP request failed: " + response.code.to_s)
        bad_response
      end
    end

    #Request running
    request.run
  end

  def good_response
    @site.update_attribute(:up, true)
  end

  def bad_response
    @site.update_attribute(:up, false)
  end

end
