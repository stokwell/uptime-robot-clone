class UriResponseWorker
  include Sidekiq::Worker
  include Typhoeus

  def perform(site_id)
    @site = Site.find_by(id: site_id)
    request = Typhoeus::Request.new(@site.url, timeout: 5)
    #The callbacks should be defined before running the request.
    request.on_complete do |response|
      if response.success?
        message = "HTTP request successed: " + response.code.to_s
        #puts response.total_time.round(3)
        logger.info(message)
        good_response
      elsif response.timed_out?
        message = "HTTP request got a time out"
        logger.info(message)
        bad_response(message)
      elsif response.code == 0
        # Could not get an http response, something's wrong.
        message = response.return_message
        logger.info(message)
        bad_response(message)
      else
        # Received a non-successful http response.
        message = "HTTP request failed: " + response.code.to_s
        logger.info(message)
        bad_response(message)
      end
    end
    #Request running
    request.run
  end

  def good_response
    @site.update(checked_at: Time.now.to_datetime)
    @site.update(up: true) unless @site.up
  end

  def bad_response(message)
    @site.update(checked_at: Time.now.to_datetime)
    @site.update(up: false) if @site.up != false
    AlertsMailer.delay.bad_response_email(@site, message)
  end
end
