class ApplicationMailer < ActionMailer::Base
  default from: ENV['CONSUMERS_CABINET_LTKE_EMAIL']
  layout 'mailer'
end
