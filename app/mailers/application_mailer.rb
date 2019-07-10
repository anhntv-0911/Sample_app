class ApplicationMailer < ActionMailer::Base
  default from: Settings.mail
  layout "mailer"
end
