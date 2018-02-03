class AlertWorker
  include Sidekiq::Worker

  def perform(site)
    user = User.find_by(id: site.user_id)
    job_id = AlertsMailer.delay.bad_response_email(user) 
  end
end
