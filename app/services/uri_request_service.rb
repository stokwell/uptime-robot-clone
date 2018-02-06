class UriRequestService
  include Sidekiq::Worker
  include Typhoeus

  def initialize(site)
    @site = site
  end

  def perform
    request = Typhoeus::Request.new(@site.url, timeout: 5)
    #The callbacks should be defined before running the request.
    request.on_complete do |response|
      if response.success?
        message = "HTTP request successed: " + response.code.to_s
        response_time = response.total_time.round(3)
        response_code = response.code
        logger.info(message)
        good_response(message)
        create_ping(response_time, response_code)
      elsif response.timed_out?
        message = "HTTP request got a time out"
        response_time = response.total_time.round(3)
        logger.info(message)
        bad_response(message)
        create_ping(response_time, response_code)
      elsif response.code == 0
        # Could not get an http response, something's wrong.
        message = response.return_message
        response_time = response.total_time.round(3)
        logger.info(message)
        bad_response(message)
        create_ping(response_time, response_code)
      else
        # Received a non-successful http response.
        message = "HTTP request failed: " + response.code.to_s
        response_time = response.total_time.round(3)
        logger.info(message)
        bad_response(message)
        create_ping(response_time, response_code)
      end
    end
    #Request running
    request.run
  end

  def good_response(message)
    @site.update(checked_at: Time.now.to_datetime)
    @site.update(up: true) unless @site.up
  end

  def bad_response(message)
    @site.update(checked_at: Time.now.to_datetime)
    @site.update(up: false) if @site.up != false
    AlertsMailer.delay.bad_response_email(@site, message)
  end

  def create_ping(response_time, response_code)
    @site.pings.create(performed_at: Time.now, response_time: response_time, response_status_code: response_code )
  end
end
