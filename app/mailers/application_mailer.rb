class ApplicationMailer < ActionMailer::Base
  # default 'Content-Transfer-Encoding' => '7bit'
  default from: Rails.configuration.unibo_common.default_from
  layout "mailer"
end
