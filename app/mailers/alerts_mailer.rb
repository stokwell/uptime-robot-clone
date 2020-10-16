class AlertsMailer < ActionMailer::Base
  default from: 'from@example.com'

  def bad_response_email(site, message)
    @message = message
    user = User.find_by(id: site.user_id)
    mail(to: user.email, subject: "Bad response for site with url: #{site.url}") do |format|
      format.text
      format.html
    end
  end

end
