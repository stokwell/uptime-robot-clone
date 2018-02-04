class AlertsMailer < ActionMailer::Base

  def bad_response_email(user, site)
    mail(to: user.email, subject: "Bad response for site with url: #{site.url}") do |format|
      format.text
      format.html
    end
  end

end
